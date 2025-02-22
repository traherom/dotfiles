set fish_greeting

fish_vi_key_bindings


# Enable command history search via fzf.                                    
function reverse_history_search
    history | fzf --no-sort | read -l command
    if test $command
        commandline -rb $command
    end
end

function fish_user_key_bindings
    # Use FZF for history if possible
    if type -q fzf
        bind -M default \cr reverse_history_search
        bind -M default / reverse_history_search
    else
        bind -M default \cr history-pager
        bind -M default / history-pager
    end
end

if type -q nvim
    set -xg EDITOR nvim
    set -xg VISUAL nvim
end

if status is-interactive
    # Interactive-only stuff
end

if type -q starship
    starship init fish | source
end
