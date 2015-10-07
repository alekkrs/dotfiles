zstyle :compinstall filename "$HOME/.zshrc"

# Path {
function add_path() {
    [[ $PATH =~ "^$1$|^$1:|:$1$|:$1:" ]] && return
    PATH=$1:$PATH
}

# user local bin
add_path $HOME/.local/bin
# }

# tmux {
function tmux_attach() {
    [[ -z "$TMUX" ]]           || return
    which tmux 2>&1 >/dev/null || return

    ID=$(tmux ls 2>/dev/null | grep -vm1 attached | cut -d: -f1)
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

# Keys {
bindkey -v
autoload -U zkbd

function zkbd_file() {
    [[ -f ~/.zkbd/${TERM}-${VENDOR}-${OSTYPE} ]] && echo -n ~/.zkbd/${TERM}-${VENDOR}-${OSTYPE} && return 0
    [[ -f ~/.zkbd/${TERM}-${DISPLAY} ]]          && echo -n ~/.zkbd/${TERM}-${DISPLAY}          && return 0
    return 1
}

[[ -d ~/.zkbd ]] || mkdir ~/.zkbd

keyfile=$(zkbd_file)
[[ $? -eq 0 ]] || zkbd
keyfile=$(zkbd_file)
[[ $? -eq 0 ]] && source $keyfile || echo "Failed to setup keys using zkbd."
unset keyfile
unfunction zkbd_file

[[ -n "${key[Home]}"   ]] && bindkey "${key[Home]}"   beginning-of-line
[[ -n "${key[End]}"    ]] && bindkey "${key[End]}"    end-of-line
[[ -n "${key[Insert]}" ]] && bindkey "${key[Insert]}" overwrite-mode
[[ -n "${key[Delete]}" ]] && bindkey "${key[Delete]}" delete-char
[[ -n "${key[Up]}"     ]] && bindkey "${key[Up]}"     up-line-or-history
[[ -n "${key[Down]}"   ]] && bindkey "${key[Down]}"   down-line-or-history
[[ -n "${key[Left]}"   ]] && bindkey "${key[Left]}"   backward-char
[[ -n "${key[Right]}"  ]] && bindkey "${key[Right]}"  forward-char

export KEYTIMEOUT=1
# }

# Completion {
autoload -Uz compinit
compinit

zstyle ':completion:*' completer _complete
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' menu select=3
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
# }

# History {
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
setopt appendhistory histignorealldups histreduceblanks
# }

# Aliases {
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -lhA'
# }

# Options {
setopt extendedglob
setopt autopushd pushdminus pushdignoredups pushdtohome
setopt automenu
# }

# Prompt {
autoload -U colors && colors

PROMPT="\
┌─[%{$fg_bold[cyan]%}%T%{$reset_color%}][%{$fg[green]%}%n%{$reset_color%}@%{$fg[green]%}%m%{$reset_color%}:%{$fg_bold[blue]%}%~%{$reset_color%}]
└─%# \
"
RPROMPT="\
"
# }

[ -e $HOME/env/base ] && . $HOME/env/base
