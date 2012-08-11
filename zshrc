# Path to your oh-my-zsh configuration.
ZSH=$HOME/.zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="robbyrussell"
ZSH_THEME="stardiviner"

# Example aliases
alias zshconfig="vim ~/.zshrc"
# alias ohmyzsh="vim ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(ssh-agent gpg-agent \
    git mercurial svn git-flow \
    compleat \
    command-not-found \
    gem pip \
    extract)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

# 256 colors TERM {{{
if [ -n "$XTERM_VERSION" ]; then # if terminal is xterm.
    if [ -e /usr/share/terminfo/x/xterm+256color ]; then
        export TERM="xterm-256color"
    fi
else
    export TERM="xterm-256color"
fi
# FIXME 13: parse error: condition expected: =
if [ "$COLORTERM" = "rxvt-xpm" ]; then # if terminal is urxvt.
    if [ -e /usr/share/terminfo/r/rxvt-unicode-256color ]; then
        export TERM="rxvt-unicode-256color"
    fi
fi
#[ -z "$TMUX" ] && export TERM=xterm-256color
#[ -z "$TMUX" ] && export TERM="screen-256color"
if [ -n "$TMUX" ]; then # if terminal is Tmux.
    export TERM="screen-256color"
fi
# }}}

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git hg bzr svn

# add user home bin/ and scripts/ into PATH
if [[ -d $HOME/bin || -d $HOME/scripts ]] ; then
    PATH=$HOME/bin:$HOME/scripts:$PATH
    export PATH
fi

# define CD Base directory
# used to command 'cd' directory.
# e.g. cd mail -> /etc/mail
export CDPATH=.:/media

# powerful redirection.
# redirect stdout and stderr to file: command |& > file
# redirect to multiple file same time: command > file.1 > file.2

# colorful man page {{{
# code meaning
# ————————-
# 0      OFF
# 1       hilight
# 4       underline
# 5       blink
# 7      inverse
# 8      invisible
#
export MANWIDTH=80 # man page width.
#export PAGER="`which less` -s"
export BROWSER="$PAGER"
export LESS_TERMCAP_mb=$'\E[01;43m'
export LESS_TERMCAP_md=$'\E[04;01;36m' # section like NAME DESCRIPTION
export LESS_TERMCAP_me=$'\E[0;37m' # [
# export LESS_TERMCAP_se=$'\E[0;37m' # down
# export LESS_TERMCAP_so=$'\E[0;40;36m' # bottom status
export LESS_TERMCAP_ue=$'\E[0;37m' # ]
export LESS_TERMCAP_us=$'\E[01;33m' # options
# }}}

# ENVIRONMENT {{{
    EDITOR=vim
    export EDITOR=vim

    # for syntax highlight LESS command (need "source-highlight")
    PAGER='less -X -M' export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s" export LESS=' -R '

    # FVWM
    #FVWM_USERDIR=$HOME/.fvwm/
    #FVWM_DATADIR=
    #FVWM_MODULEDIR=
    #SESSION_MANAGER=
    #SESSION_MANAGER_NAME=
    #SM_SAVE_DIR=

    # locale
    export LC_ALL=en_US.utf-8
    export LANG=en_US.UTF-8

    # vim like key binds mode.
    # set -o vi
# }}}

# gpg-agent require settings & vim plugin vim-gnupg.vim {{{
GPG_TTY=$(tty)
export GPG_TTY
# ssh-agent
zstyle :omz:plugins:ssh-agent agent-forwarding on # enable agent forwarding
zstyle :omz:plugins:ssh-agent id_rsa id_rsa2 id_github # load multiple identies
# }}}

# corrections {{{
# 1:
#zstyle ':completion::approximate:' max-errors 1 numeric
# 2:
zstyle ':completion:' completer _complete _match _approximate
zstyle ':completion::match:' original only
zstyle ':completion::approximate:*' max-errors 1 numeric
# }}}

# history {{{
# add timestamps to command history file.
setopt EXTENDED_HISTORY
# use history for command "cd", cd - [TAB] to go to path history.
setopt AUTOPUSHD
# same history path only keep one.
setopt PUSHDIGNORE_DUPS
# ignore this command in history if add space before command.
setopt HISTIGNORESPACE
# use comment in interactive mode
# }}}

# record sudo command history into syslog {{{
zshaddhistory() {
    cmd=${1%%$'\n'}
    print -sr -- $cmd
    LASTCMD="${(pj:\\\n:)${(f)1}}"
    first_arg=${${(z)LASTCMD}[1]}
    ( [[ `id -u $USER` -eq 0 ]] || [[ $first_arg == sudo ]] ) && logger -t "$USER@${TTY/\/dev\/}[$PWD]" $LASTCMD
}
# }}}

# confirm when reboot/halt/shutdown {{{
confirm_yes() {
    sure=$(dialog --stdout  --inputbox "Are you sure that you want to run '$1' command? Type YES to confirm." 10 50)
    [[ $sure == YES ]] && $1
}

for c in reboot halt shutdown; do alias $c="confirm_yes $c"; done
# }}}

# e.g. $ cmd # this is comment
setopt INTERACTIVE_COMMENTS
# line edit highlight mode
# Ctrl+@ set mark, between marks and cursor is "region".
zle_highlight=(region:bg=magenta # choose region.
                special:bold # special characters
                isearch:underline) # keywords when searching.

# Zsh filetype association {{{
autoload -U zsh-mime-setup
zsh-mime-setup
# alias -s [extension]=[program]
# so that you only need use <Tab> to complete filename.png,
alias -s png=feh
alias -s jpg=feh
# }}}

# [ auto-fu.zsh ] {{{
    ## way-1: source it
    ## 1) source this file.
    #source $ZSH/plugins/auto-fu/auto-fu.zsh
    ## 2) establish `zle-line-init' containing `auto-fu-init' something like below.
    #zle-line-init () {auto-fu-init;}; zle -N zle-line-init
    ## 3) use the _oldlist completer something like below.
    #zstyle ':completion:*' completer _oldlist _complete
    ## (If you have a lot of completer, please insert _oldlist before _complete.)
    ## 4) establish `zle-keymap-select' containing `auto-fu-zle-keymap-select'.
    #zle -N zle-keymap-select auto-fu-zle-keymap-select
    ## (This enables the afu-vicmd keymap switching coordinates a bit.)

    ## way-2: zcompile the necessary functions.
    ## *1) zcompile the defined functions. (generates ~/.zsh/auto-fu.zwc)
    #A=$ZSH/plugins/auto-fu/auto-fu.zsh; (zsh -c "source $A ; auto-fu-zcompile $A ~/.zsh/plugins/auto-fu")
    ## *2) source the zcompiled file instead of this file and some tweaks.
    #source ~/.zsh/plugins/auto-fu/auto-fu; auto-fu-install
    ## *3) establish `zle-line-init' and such (same as a few lines above).

    ## configuration {{{
    #zle-line-init () {auto-fu-init;}; zle -N zle-line-init
    #zstyle ':completion:*' completer _oldlist _complete
    #zle -N zle-keymap-select auto-fu-zle-keymap-select
    ## ~~~~~~~~~~~~~~~
    ## zstyle ':auto-fu:highlight' input bold
    #zstyle ':auto-fu:highlight' input fg=green
    #zstyle ':auto-fu:highlight' completion fg=red,bold
    #zstyle ':auto-fu:highlight' completion/one fg=green,bold,underline
    ## zstyle ':auto-fu:var' postdisplay $'\n-azfu-'
    #zstyle ':auto-fu:var' postdisplay $'\n ♪ »'
    #zstyle ':auto-fu:var' postdisplay/clearp 'yes' # FIXME cleanup init zcompile.
    #zstyle ':auto-fu:var' enable all
    #zstyle ':auto-fu:var' disable magic-space
    ##zstyle ':auto-fu:var' track-keymap-skip opp
    #clear # clear zcompile output
    ## }}}

    # clean version {{{
    # precompiled source
    function () {
    local A
    A=~/.zsh/custom/plugins/auto-fu/auto-fu.zsh
    [[ -e "${A:r}.zwc" ]] && [[ "$A" -ot "${A:r}.zwc" ]] ||
    zsh -c "source $A; auto-fu-zcompile $A ${A:h}" >/dev/null 2>&1
    }
    source ~/.zsh/custom/plugins/auto-fu/auto-fu; auto-fu-install

    # initialization and options
    function zle-line-init () {auto-fu-init}
    zle -N zle-line-init
    zstyle ':auto-fu:highlight' input bold
    zstyle ':auto-fu:highlight' completion fg=white
    zstyle ':auto-fu:var' postdisplay ''
    zstyle ':completion:*' completer _oldlist _complete

    zle -N zle-keymap-select auto-fu-zle-keymap-select
    # ~~~~~~~~~~~~~~~
    zstyle ':auto-fu:highlight' input bold
    zstyle ':auto-fu:highlight' input fg=green
    zstyle ':auto-fu:highlight' completion fg=red,bold
    zstyle ':auto-fu:highlight' completion/one fg=green,bold,underline
    zstyle ':auto-fu:var' postdisplay $'\n Ϟ'
    zstyle ':auto-fu:var' postdisplay/clearp 'yes'
    zstyle ':auto-fu:var' enable all
    zstyle ':auto-fu:var' disable magic-space
    # clear # clear zcompile output
    # }}}

# }}}
