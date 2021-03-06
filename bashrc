# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Determine where our dotfiles are located
if [ -f "$HOME/.dotfiles" ]; then
  source "$HOME/.dotfiles"
fi

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+:}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

# Fancy prompt
in_ssh() {
  if [[ "$1" == "" ]]; then
    local ppid="$PPID"
  else
    local ppid="$1"
  fi

  local comm="$(ps -o comm= $ppid)"
  local pppid="$(ps -o ppid= $ppid)" # Parent's PPID

  if [[ "$comm" == "sshd" ]]; then
    echo "ssh"
  elif [[ "$pppid" > 1 ]]; then
    in_ssh $pppid
  else
    echo ""
    return 0
  fi
}
ps_user() {
  if [[ `whoami` != "traherom" ]]; then
    echo "\u"
  fi
}
ps_host() {
  if [[ `in_ssh` == "ssh" ]]; then
    echo "@\[\033[1;34m\]\h\[\033[00m\]:"
  fi
}
ps_git() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
ps_chroot() {
  echo "${debian_chroot:+($debian_chroot)}"
}
ps_wd() {
  echo "\[\033[32m\]\w\[\033[33m\]"
}
export -f ps_git
export PS1="\n$(ps_chroot)$(ps_user)$(ps_host)$(ps_wd)\$(ps_git) \n\[\033[00m\]$ "

if [[ "$color_prompt" != "yes" ]]; then
  PS1='\n${debian_chroot:+($debian_chroot)}\u@\h:\w\n\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
# Use the correct form of ls (bsd/gnu)
export CLICOLOR=""
export LSCOLORS=""
if `ls --color=auto >/dev/null 2>&1`; then
    alias ls='ls -F --color=auto'
else
    alias ls='ls -FG'
fi

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Change keybindings
if [ -f ~/.bash_key_bindings ]; then
    bind -f ~/.bash_key_bindings
fi

# On anything without an open command, make one
if [[ `uname` != 'Darwin' ]]
then
	alias open=xdg-open
fi

# Always use 256 colors for tmux
alias tmux='tmux -2'

# Add user bin directory to PATH
export ANDROID_NDK_HOME="/opt/android-ndk"
export PATH="/usr/local/sbin:/usr/local/bin:$PATH:$HOME/bin:$HOME/.cargo/bin:$DOTFILES_BASE/bin:$HOME/.local/bin:/Applications/Android Studio.app/sdk/tools:/Applications/Android Studio.app/sdk/platform-tools:$ANDROID_NDK_HOME:/opt/apktool:/usr/local/go/bin"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/lib"
export GOPATH="$HOME/go"

# Add all GOPATH bins to PATH
export PATH="$PATH:${GOPATH//://bin:}/bin"

# Enable virtualenvwrapper, assuming it's installed
export WORKON_HOME="$HOME/venvs"
export VIRTUALENVWRAPPER_PYTHON=python3
if command -v virtualenvwrapper.sh >/dev/null 2>&1; then
  mkdir -p "$WORKON_HOME"
  source `command -v virtualenvwrapper.sh`
fi

# xclip helpers
alias setclip="xclip -selection c"
alias getclip="xclip -selection c -o"

# Add anything needed for just this machine
MACHINE_SPECIFIC="$HOME/.bash_local"
if [ -e "$MACHINE_SPECIFIC" ]; then
	source "$MACHINE_SPECIFIC"
fi

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# Pyenv
export PIP_REQUIRE_VIRTUALENV=true
export PATH="$HOME/.pyenv/bin:$HOME/.pyenv/shims:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
source ~/.pyenv/completions/pyenv.bash


export NVM_DIR="/home/traherom/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# Only set up minikube if it's running
# if ! minikube status | grep minikube | grep Stopped >/dev/null; then
#   # eval $(minikube docker-env)
#   source <(minikube completion bash)
# fi

if command -v kubectl >/dev/null 2>&1; then
  source <(kubectl completion bash)
fi


# The next line updates PATH for the Google Cloud SDK.
if [ -f ~/Downloads/google-cloud-sdk/path.bash.inc ]; then
  source ~/Downloads/google-cloud-sdk/path.bash.inc;
fi

# The next line enables shell command completion for gcloud.
if [ -f ~/Downloads/google-cloud-sdk/completion.bash.inc ]; then
  source ~/Downloads/google-cloud-sdk/completion.bash.inc;
fi

if [ -d ~/src/xylok ]; then
  xylok() { cd ~/src/xylok ; }

  if grep -q Microsoft /proc/version; then
    echo "Detected Linux on Windows, switching to Xylok folder"
    xylok
  fi
fi

eval "$(starship init bash)"

