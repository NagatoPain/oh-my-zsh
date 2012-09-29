# check out Main page: http://mldonkey.sourceforge.net/Main_Page
# commands: http://mldonkey.sourceforge.net/MLdonkeyCommandsExplained

# http://mldonkey.sourceforge.net/TelnetUI
# http://mldonkey.sourceforge.net/TelnetCommandScripts
# http://mldonkey.sourceforge.net/Broadcatch
# http://mldonkey.sourceforge.net/StartStopStatusScript
# http://mldonkey.sourceforge.net/File_completed_cmd
# http://mldonkey.sourceforge.net/SymlinkTempFiles
# http://mldonkey.sourceforge.net/ExternalSearchUtilities
# http://mldonkey.sourceforge.net/Secure_web_access_via_ssl_of_your_mldonkey_client
# http://mldonkey.sourceforge.net/SshTunnel
# http://mldonkey.sourceforge.net/Browser_Integration

local mldonkey_IP=localhost
local mldonkey_port=4000
local mldonkey_USERNAME=admin
if [[ -z $mldonkey_PASSWORD ]]; then
    # FIXME if variable empty, then read from input prompt.
    local mldonkey_PASSWORD="PASSWORD"
fi

# Supported System Signals
# - SIGHUP
#   -- All files and open sockets are cloesd
#   -- This is a useful command for an ip-up script on a connection with a 
#   dynamic IP to notify MLDonkey that the IP has changed.
#   -- Note that a connection to a GUI is also cloes.
# - SIGINIT / SIGTERM
#   -- Save all configuration data and stop core.
# - SIGUSR1
#   -- save options
# - SIGUSR2
#   -- performs garbage collection.

local function send2control() {
    if [[ "$1" == "nc" ]]; then
        nc $mldonkey_IP $mldonkey_port
    elif [[ "$1" == "telnet" ]]; then
        telnet $mldonkey_IP $mldonkey_port
    fi
}

function mldonkey_f() {
    case $1 in
        help)
            # FIXME the \ is error in zsh.
            echo -e "help\nq" \
                | send2control("nc")
            ;;
        login)
            telnet $mldonkey_IP $mldonkey_port
            ;;
        auth)
            echo -e "auth $mldonkey_USERNAME $mldonkey_PASSWORD" \
                | send2control("nc")
            ;;
        download)
            echo -e "dllink $2" \
                | send2control("nc")
            ;;
        commit)
            # commit (if you have password, you need to auth)
            echo -e "auth $mldonkey_USERNAME $mldonkey_PASSWORD\ncommit\nq" \
                | send2control("nc")
            # or
            # (echo "commit"; sleep 2) | telnet $mldonkey_IP 4000
            # or if you have no password
            # echo -e "commit\nq" | nc localhost 4000
            ;;
        view_downloadings)
            # echo downloading files
            echo "auth $mldonkey_USERNAME $mldonkey_PASSWORD\nvd\nq" \
                | send2control("nc") \
                | sed "/Paused/d" | sed "/- *$/d"
            ;;
        search)
            # > longhelp s
            # special args:
            #   -minsize <size>
            #   -maxsize <size>
            #   -media <Video|Audio|..>
            #   -Video
            #   -Audio
            #   -format <format>
            #   -title <word in title>
            #   -album <word in album>
            #   -artist <word in artist>
            #   -field <field> <fieldvalue>
            #   -not <word>
            #   -and <word>
            #   -or <word>
            ;;
        set_dl_rate)
            if [ $# == 2 ];
                echo -e "auth $mldonkey_USERNAME $mldonkey_PASSWORD\nset max_hard_download_rate $2\nq" \
                    | send2control("nc")
            done
            ;;
        set_up_rate)
            if [ $# == 2 ];
                echo -e "auth $mldonkey_USERNAME $mldonkey_PASSWORD\nset max_upload_rate $2\nq" \
                    | send2control("nc")
            done
            ;;
        max_speed)
            echo -e "auth $mldonkey_USERNAME $mldonkey_PASSWORD\nset max_upload_rate 250\nset max_upload_rate 20\nq" \
                | send2control("nc")
            ;;
        *)
            # for invoking any commands:
            echo "$1\nq" \
                | send2control("nc")
            ;;
    esac
}
