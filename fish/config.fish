# Add Go
set -gx GOPATH $HOME/go
if test -d /usr/local/go/bin >/dev/null
    set -gx PATH /usr/local/go/bin/ $PATH
end
if test -d ~/go/bin >/dev/null
    set -gx PATH ~/go/bin $PATH
end

# Add personal binaries
set -gx PATH ~/bin ~/.local/bin $PATH

# Pyenv
set -x PATH "/home/traherom/.pyenv/bin" $PATH
status --is-interactive; and . (pyenv init -|psub)
status --is-interactive; and . (pyenv virtualenv-init -|psub)

# Pipenv
eval (pipenv --completion)

# Python/venv
# eval (/usr/bin/python3 -m virtualfish auto_activation)

