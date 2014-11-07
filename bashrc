# if not running interactively, don't do anything
[ -z "$PS1" ] && return

# Path {
function add_path() {
    [[ $PATH =~ ^$1$|^$1:|:$1$|:$1: ]] && return
    PATH=$1:$PATH
}

# user local bin
add_path $HOME/.local/bin
# }

# tmux {
function tmux_attach() {
    [[ -z "$TMUX" ]]           || return
    which tmux 1>&2 >/dev/null || return

    ID=$(tmux ls | grep -vm1 attached | cut -d: -f1)
    if [[ -z "$ID" ]]; then
        exec tmux new-session
    else
        exec tmux attach-session -t $ID
    fi
}

# create or attach to session
tmux_attach
# }

# Env {
# editor
export EDITOR='vim'
# less
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"
# dircolors
[ -x /usr/bin/dircolors ] && eval "$(dircolors -b)"
# }

# Completion {
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
# }

# History {
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend
# }

# Aliases {
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -lhA'
# }

# Options {
shopt -s globstar
shopt -s checkwinsize
# }

# Prompt {
# chroot
[ -r /etc/debian_chroot ] && debian_chroot=$(cat /etc/debian_chroot)

PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# }

[ -e $HOME/env/base ] && . $HOME/env/base
