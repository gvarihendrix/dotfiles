fish_ssh_agent

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# fish_ssh_agent

set -x LANG en_US.UTF-8


function fish_right_prompt -d "Write out the right prompt"
    date '+%H:%M'
end

source ~/.asdf/asdf.fish

alias vim=nvim
