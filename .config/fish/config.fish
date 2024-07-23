set -l os (uname)


switch (uname)
       case Darwin
            eval (/opt/homebrew/bin/brew shellenv)
            fnm --log-level quiet env --use-on-cd | source
            source ~/.asdf/asdf.fish
            echo "This is Darwin/Apple"
       case Linux
            echo "This is linux"
end


fish_ssh_agent
starship init fish | source
zoxide init fish | source
direnv hook fish | source
set -g direnv_fish_mode eval_on_arrow # trigger direnv at prompt, and on every arrow-based directory change

set -U fish_greeting
set -U fish_key_binding fish_vi_key_binding

set -Ux EDITOR nvim
set -Ux FZF_DEFAULT_COMMAND "fd -H -E '.git'"
set -Ux VISUAL nvim


fish_add_path $HOME/.config/bin

if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -x LANG en_US.UTF-8

function fish_right_prompt -d "Write out the right prompt"
    date '+%H:%M'
end

alias vim=nvim
