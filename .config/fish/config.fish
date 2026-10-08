switch (uname)
    case Darwin
        eval (/opt/homebrew/bin/brew shellenv)
        source /opt/homebrew/opt/asdf/share/fish/vendor_completions.d/asdf.fish
    case Linux
end

# fish_ssh_agent
starship init fish | source
zoxide init fish | source
direnv hook fish | source
set -g direnv_fish_mode eval_on_arrow # trigger direnv at prompt, and on every arrow-based directory change

set -U fish_greeting
set -U fish_key_binding fish_vi_key_binding

set -Ux EDITOR nvim
set -Ux FZF_DEFAULT_COMMAND "fd -H -E '.git'"
set -Ux VISUAL nvim

# ASDF configuration code
if test -z $ASDF_DATA_DIR
    set _asdf_shims "$HOME/.asdf/shims"
else
    set _asdf_shims "$ASDF_DATA_DIR/shims"
end

# Do not use fish_add_path (added in Fish 3.2) because it
# potentially changes the order of items in PATH
if not contains $_asdf_shims $PATH
    set -gx --prepend PATH $_asdf_shims
end
set --erase _asdf_shims

fish_add_path $HOME/.config/bin

if status is-interactive; and not set -q KIROCREW_SPAWNED
    # Commands to run in interactive sessions can go here.
    # Guarded against KIROCREW_SPAWNED: KiroCrew agent shells are interactive
    # but must not auto-start a zellij server — those servers outlive the
    # session's scratch dir and leak ptys (orphaned `zellij --server`).
    eval (zellij setup --generate-auto-start fish | string collect)
end

set -x LANG en_US.UTF-8

if set -q ZELLIJ; or set -q KIROCREW_SPAWNED
    # Already inside zellij, OR a KiroCrew-spawned agent shell: do NOT start a
    # server. Agent shells are short-lived and their scratch dir is deleted on
    # session end, so a zellij server started here becomes an orphan holding
    # ptys forever (the per-session zellij-server leak).
else
    # Start zellij if it is not already running
    zellij
end

# Load Terraform Cloud credentials
if test -f ~/.terraform.d/credentials.tfrc.json
    set -gx TF_TOKEN_app_terraform_io (cat ~/.terraform.d/credentials.tfrc.json | jq -r '.credentials."app.terraform.io".token')
    set -gx TF_CLI_CONFIG_FILE ~/.terraform.d/credentials.tfrc.json
end

function fish_right_prompt -d "Write out the right prompt"
    date '+%H:%M'
end

function awsgo --description "Login to AWS using SSO and kubernetes if --kube or -k flags are set"
    set -e AWS_ACCESS_KEY_ID
    set -e AWS_SECRET_ACCESS_KEY
    set -e AWS_SESSION_TOKEN
    set -e AWS_REGION
    set -gx AWS_PROFILE $argv[1]

    argparse h/help k/kube -- $argv

    if set -ql _flag_help
        echo "Usage: awsgo [-h|--help] [-k|--kube] [profile]"
        echo "If -k or --kube are set then the function will try to connect to kubernetes cluster as well"
        return 0
    end

    # Try to get caller identity, if it fails, do SSO login
    if not aws sts get-caller-identity >/dev/null 2>&1
        aws sso login
    end

    # Export credentials to environment
    eval (aws configure export-credentials --format env)

    # Check if we want to connect to kubernetes cluster as well.
    if set -ql _flag_kube
        kubeconnect
    end
end

function kubeconnect
    set -l credentials $(aws sts get-caller-identity)
    set -l account "$(echo "$credentials" | jq -r .Account)"
    set -l kube_context "$(kubectl config get-clusters | rg -o "\S+:$account:\S+" | head -n 1)"

    echo "Kube context that you are trying to connecting to $kube_context"
    set -l length_of_context $(string length $kube_context)

    if test $length_of_context -eq 0
        echo "No kube context for acccount named $account"
    else
        kubectl config use-context "$kube_context"
    end
end

# Create completion function for awsgo
function __fish_aws_profiles
    # Read AWS profiles from config file
    string match -r '^\[profile (.+)\]' <$HOME/.aws/config | string replace -r '^\[profile (.+)\]' '$1'
end

# function unset 
#     set --erase --no-scope-shadowing $argv
# end 

# Register completion for awsgo
complete -c awsgo -f -a "(__fish_aws_profiles)" -d "AWS profile"
complete -c kubeconnect -d "Connect to kubernetes cluster, note this is only setup to be used when you have already logged into AWS"

function sshagent_findsockets
    find /tmp -uid (id -u) -type s -name agent.\* 2>/dev/null
end

function sshagent_testsocket
    if [ ! -x (command which ssh-add) ]
        echo "ssh-add is not available; agent testing aborted"
        return 1
    end

    if [ X"$argv[1]" != X ]
        set -xg SSH_AUTH_SOCK $argv[1]
    end

    if [ X"$SSH_AUTH_SOCK" = X ]
        return 2
    end

    if [ -S $SSH_AUTH_SOCK ]
        ssh-add -l >/dev/null
        if [ $status = 2 ]
            echo "Socket $SSH_AUTH_SOCK is dead!  Deleting!"
            rm -f $SSH_AUTH_SOCK
            return 4
        else
            # printf "Found ssh-agent $SSH_AUTH_SOCK"
            return 0
        end
    else
        echo "$SSH_AUTH_SOCK is not a socket!"
        return 3
    end
end

function ssh_agent_init
    # ssh agent sockets can be attached to a ssh daemon process or an
    # ssh-agent process.
    set -l AGENTFOUND 0

    # Attempt to find and use the ssh-agent in the current environment
    if sshagent_testsocket
        set AGENTFOUND 1
    end

    # If there is no agent in the environment, search /tmp for
    # possible agents to reuse before starting a fresh ssh-agent
    # process.
    if [ $AGENTFOUND = 0 ]
        for agentsocket in (sshagent_findsockets)
            if [ $AGENTFOUND != 0 ]
                break
            end
            if sshagent_testsocket $agentsocket
                set AGENTFOUND 1
            end

        end
    end

    # If at this point we still haven't located an agent, it's time to
    # start a new one
    if [ $AGENTFOUND = 0 ]
        echo need to start a new agent
        eval (ssh-agent -c)
    end

    # Finally, show what keys are currently in the agent
    # ssh-add -l
end

function env2fish
    if not isatty
        while read line
            set --append argv $line
        end
    end
    string replace -- = ' ' $argv |
        string replace -r -- '^export' --export |
        string replace -r '^(.)' 'set -g $1'
end

ssh_agent_init

alias vim=nvim
alias tf=terraform
alias tg=terragrunt
# Alias for corepack commands 
# alias yarn="corepack yarn"
# alias yarnpkg="corepack yarnpkg"
# alias pnpm="corepack pnpm"
# alias pnpx="corepack pnpx"
# alias npm="corepack npm"
# alias npx="corepack npx"
alias less=nvimpager
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH
set -gx PATH "$HOME/.local/bin" $PATH
set -gx TG_TF_PATH /opt/homebrew/bin/tofu

if test -e "$HOME/.config/ai/env.fish"
    echo ".config/ai/env.fish exists"
    source "$HOME/.config/ai/env.fish"
end

function envsource
    for line in (cat $argv | grep -v '^#' | grep -v '^\s*$')
        set -l kv (string split -m 1 '=' $line)
        set -l key $kv[1]
        set -l val $kv[2]
        # strip surrounding single/double quotes
        set val (string trim --chars='"\'' -- $val)
        # expand $HOME and $VAR references
        set val (string replace -r '\$HOME' $HOME -- $val)
        set -gx $key $val
    end
end

# Load kiro's shell integration (inline autocomplete) only in genuine
# interactive terminals -- NOT in KiroCrew-spawned agent/gateway shells.
# Those spawn a figterm pty-wrapper subshell that is never reaped on abrupt
# parent death, leaking ~2 ptys per session until kern.tty.ptmx_max is hit.
# KIROCREW_SPAWNED is set only in those agent shells, so this skips exactly them.
if status is-interactive; and not set -q KIROCREW_SPAWNED; and string match -q "$TERM_PROGRAM" kiro
    . (kiro --locate-shell-integration-path fish)
end
