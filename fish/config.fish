# Add Go
set -gx GOPATH $HOME/go
set -gx PATH /usr/local/go/bin/ $PATH

# Add personal binaries
set -gx PATH ~/go/bin ~/bin $PATH

# Python/venv
eval (/usr/bin/python3 -m virtualfish auto_activation)

