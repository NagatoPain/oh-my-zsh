# Path to your oh-my-zsh configuration.
ZSH=$HOME/.zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="robbyrussell"
ZSH_THEME="stardiviner"

# Example aliases
# alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git mercurial svn \
    ssh-agent gpg-agent \
    compleat \
    command-not-found \
    extract)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

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
