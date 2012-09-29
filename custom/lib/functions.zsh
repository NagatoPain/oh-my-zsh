# ======== custom ==============
# FIXME use 'local' for function local variables
# inner functions {{{
# FIXME

# function funcargs() {
#     case $1 in
#         number)
#             if $(( $2 != $3 )); then
#                 showhelp()
#             fi
#             ;;
#         *)
#             exit 1
#             ;;
#     esac
# }

# # FIXME
# function showhelp() {
#     # FIXME how to write this HELP ?
#     echo <<HELP
#     HELP
# }
# # }}}

# Vim {{{
# FIXME
function Vim() {
    # funcArgs("number", $#, 1)
    case $1 in
        vimwiki)
            # vim -c "normal \ww" +Calendar
            vim +VimwikiIndex
            ;;
        diary)
            vim +VimwikiDiaryIndex +Calendar
            ;;
        vimrc)
            vim ~/.vim/vimrc
            ;;
        man)
            vim +ViewDocMan "$2"
            ;;
        sudo)
            if [ -e /usr/bin/sudoedit ]; then
              sudoedit "$2"
            else
              vim +e sudo:"$2" # use SudoEdit.vim plugin.
            fi
            ;;
        # benchmarking)
        startuptime)
	    if [ -z "$2" ]; then
		vim --startuptime VimStartuptime.log -c qa
	    else
		vim --startuptime VimStartuptime.log "$2" -c qa
	    fi
	    vim -c 'r ! cat VimStartuptime.log| sort -k 2'
	    rm -f VimStartuptime.log
            ;;
        compile)
            function VimConfigure() {
            # --enable-pythoninterp=no/dynamic/yes
            # --enable-python3interp=no/dynamic/yes
            # --enable-gui=auto/no/gtk2/gnome2/motif/athena/neXtaw/photon/carbon

                ./configure \
                --enable-fontset \
                --enable-multibyte \
                --enable-xim \
                --enable-cscope \
                --enable-perlinterp=yes \
                --enable-luainterp=yes \
                --enable-rubyinterp=yes \
                --enable-python3interp=yes \
                --enable-gui=gtk2 \
                --with-x \
                --with-global-runtime \
                --with-features=huge \
                --with-compiledby=stardiviner
            }

            function VimCompileClean() {
                make uninstall
                make clean
            }

            function VimCompile() {
                make
            }

            hg pull ; hg update
            VimCompileClean ; VimConfigure ; VimCompile
            ;;
        *)
            if [ -e "$1" ]; then
                vim "$1"
            else
                echo "file $1 does not exist."
            fi
            ;;
    esac
}
# }}}

# # tmux {{{
# # FIXME
# function tmux_f() {
#     if [[ -n "$TMUX" ]]; then
#         continue # jump out.
#     else
#         tmux # create a new tmux session
#     fi

#     # attach window.
#     tmux list-sessions
#     # TODO prompt SOURCE_SESSION here.
#     tmux list-windows -t SOURCE_SESSION
#     # TODO prompt WINDOW here.
#     tmux new-session -ds NEW_SESSION
#     tmux link-window -kt NEW_SESSION:0 -s SOURCE_SESSION:WINDOW
#     tmux attach -t NEW_SESSION
# }
# # }}}

# volume {{{
# FIXME
function volume() {
    volumeValue=$(amixer sget Master | tail -1 | cut -d ' ' -f 5)
    case $1 in
        toggle)
            amixer -q sset Master toggle ;;
        mute)
            amixer -q sset Master mute ;;
        unmute)
            amixer -q sset Master unmute ;;
        *)
            # FIXME this match invalid
            case $1 in
                [+-]*[!0-9]*)
                    echo "invalid integer for volume value." ;;
                [+-][0-9]*) # matches +10, -9, -23 etc
                    amixer -q sset Master $(($volumeValue + $1)) ;;
                *[!0-9]*)
                    echo "invalid integer for volume value." ;;
                *) # matches 10, 23 etc
                    amixer -q sset Master playback $1% ;;
            esac
    esac
}
# }}}

# Awesome configs {{{
function awesome_f() {
    case $1 in
        check)
            awesome -k
            ;;
        restart)
            echo "awesome.restart()" | awesome-client
            ;;
        quit)
            echo "awesome.quit()" | awesome-client
            ;;
        xprop)
            xprop | grep -e CLASS -e ROLE
            ;;
        xev)
            xev | grep -A2 --line-buffered '^KeyRelease' \
                | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'
            ;;
        *)
            echo "Error: no this usage: awesome_f $1"
            exit 1
            ;;
    esac
}
# }}}

# Conky {{{
function conky_f() {
    case $1 in
        reload)
            killall -SIGUSR1 conky
            ;;
        debug)
            conky -D
            ;;
        debug_more)
            conky -DD
            ;;
        *)
            echo "Error: no this usage: conky_f $1"
            exit 1
            ;;
    esac
}
# }}}

# MPlayer {{{
function mplayer_f() {
    case $1 in
        radio)
            if [[ "$2" == "pop" ]]; then
                mplayer -loop 0 mms://live.cri.cn/pop
            elif [[ "$2" == "english" ]]; then
                mplayer -loop 0 mms://live.cri.cn/english
            fi
            ;;
        *)
            echo "Error: no this usage: mplayer_f $1"
            exit 1
            ;;
    esac
}
# }}}

# wget {{{
# FIXME
function wget_f() {
    case $1 in
        clone_website)
            wget -r -p -k -np -nc --follow-ftp --limit-rate=80k "$2"
            ;;
        *)
            wget $*
            ;;
    esac
}
# }}}

# Python {{{
function python_f() {
    case $1 in
        simplehttpserver)
            if [[ -e /usr/bin/python3 ]]; then
                python3 -m http.server
            else
                # use python 2
                python2 -m SimpleHTTPServer
            fi
            ;;
    esac
}
# }}}

# Speak (translate dict speak) {{{
# e.g. $ speak hello world
function speak() {
    if [[ $# == 0 ]]; then
        echo "Usage: $ speak hello world"
    fi
    local IFS=+; mplayer "http://translate.google.com/translate_tts?q=$*"
}
# }}}

# Play Around {{{
function backgroundVideo() {
    if [[ $# == 0 ]]; then
        echo "Usage: $ backgroundVideo ~/Videos/NotLove.avi"
    elif [[ -e $1 && $# == 1 ]]; then
        mplayer --loop 3 "$1" -rootwin -vf scale=1000:400 -noconsolecontrols
    else
        echo "Usage: $ backgroundVideo ~/Videos/NotLove.avi"
        exit 1
    fi
}

# shine the screen like emergency, Ctrl-C to stop.
# FIXME
function emergency() {
    if [[ $# == 0 ]]; then
        echo "Usage: shine screen, press <Ctrl-C> to cancel."
        while true; do
            xset dpms force off
            sleep 0.3
            xset dpms force on
            xset s reset
            sleep 0.3
        done
    fi
}
# }}}

# # Proxy {{{
# # FIXME
# function proxy() {
#     # check proxies function
#     # proxy off function
#     # proxy on function
#     # proxy error function
#     # proxy variable function
#     function proxy.f() {
#         # FIXME
#         function proxy_check() {
#         }
#         function proxy_off() {
#             unset HTTP_PROXY
#             unset http_proxy
#             unset FTP_PROXY
#             unset ftp_proxy
#             echo -e "\nProxy environment variable removed."
#         }
#         PROXY_ERROR() {
#             echo "syntax: proxy_on_ [remote|local] [on|off]"
#         }
#         PROXY_VARIABLE() {
#             echo -e "\nProxy environment variable set."
#             echo -e "\n$username : $password"
#             echo -e "\n$server : $port"
#         }
#         if [ "$#" != "2" ]; then
#             PROXY_ERROR
#         fi
#         if [ "$1" = "remote" ]; then
#             case "$2" in
#                 on)
#                     # FIXME add a proxy_check at here.
#                     echo -n "username:"
#                     read -e username
#                     echo -n "password:"
#                     read -es password
#                     export http_proxy="http://$username:$password@proxyserver:8080/"
#                     export ftp_proxy="http://$username:$password@proxyserver:8080/"
#                     PROXY_VARIABLE
#                     ;;
#                 off)
#                     proxy_off
#                     ;;
#                 *)
#                     PROXY_ERROR
#                     ;;
#             esac
#         fi
#         if [ "$1" = "local" ]; then
#             case "$2" in
#                 on)
#                     # FIXME add a proxy_check at here.
#                     echo -n "server:"
#                     read -e server
#                     echo -n "port:"
#                     read -e port
#                     export http_proxy="http://$server:$port/"
#                     export ftp_proxy="ftp://$server:$port/"
#                     PROXY_VARIABLE
#                     ;;
#                 off)
#                     proxy_off
#                     ;;
#                 *)
#                     PROXY_ERROR
#                     ;;
#             esac
#         fi
#     }
# }
# # }}}

# # package manager {{{
# # TODO reference .zsh/plugins/debian & arch
# function pkg() {
#     # detect current system: Debian/Ubuntu, Arch, Fedora.
#     Issue=$(cat /etc/issue)
#     case Issue in
#         Ubuntu)
#             DistroSystem="Ubuntu"
#             pkgmanager="aptitude"
#             ;;
#     esac

#     case $1 in
#         search)
#             # FIXME how to get parameters for $2~$*
#             sudo $pkgmanager search ???
#             ;;
#         show)
#             $pkgmanager show ???
#             ;;
#         install)
#             sudo $pkgmanager install ???
#             ;;
#         remove)
#             sudo $pkgmanager remove ???
#             ;;
#         purge)
#             sudo $pkgmanager purge ???
#             ;;
#         update)
#             sudo $pkgmanager update
#             ;;
#         safeupgrade)
#             sudo $pkgmanager update
#             sudo $pkgmanager safe-upgrade
#             ;;
#         fullupgrade)
#             sudo $pkgmanager update
#             sudo $pkgmanager full-upgrade
#             ;;
#         *)
#             echo "error"
#             ;;
#     esac

#     # # Debian/Ubuntu {{{ aptitude & apt-get
#     # function apt() {
#     #     case $1 in
#     #         search)
#     #             sudo aptitude search $2~$*
#     #             ;;
#     #         show)
#     #             sudo aptitude show $2~$*
#     #             ;;
#     #         why)
#     #             sudo aptitude why $2~$*
#     #             ;;
#     #         whynot)
#     #             sudo aptitude whynot $2~$*
#     #             ;;
#     #         update)
#     #             sudo aptitude update $2~$*
#     #             ;;
#     #         install)
#     #             sudo aptitude install $2~$*
#     #             ;;
#     #         remove)
#     #             sudo aptitude remove $2~$*
#     #             ;;
#     #         purge)
#     #             sudo aptitude purge $2~$*
#     #             ;;
#     #         safeupgrade)
#     #             sudo aptitude update
#     #             sudo aptitude safe-upgrade
#     #             ;;
#     #         fullupgrade)
#     #             sudo aptitude update
#     #             sudo aptitude full-upgrade
#     #             ;;
#     #         cleancache)
#     #             sudo aptitude clean
#     #             ;;
#     #         add_pubkey)
#     #             sudo apt-key adv --keyserver keys.gnupg.net --recv-key $2~$*
#     #             sudo aptitude update
#     #             ;;
#     #         removeOldKernel)
#     #             function removeOldKernel() {
#     #             }
#     #             ;;
#     #         *)
#     #             echo "error ??"
#     #             ;;
#     #     esac
#     # }
#     # # }}}

#     # Arch {{{ pacman
#     function pacman_f() {
#     }
#     # }}}

#     # Fedora {{{ rpm
#     function rpm_f() {
#     }
#     # }}}
# }
# # }}}


# vim:fdm=marker
