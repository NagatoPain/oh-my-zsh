# TODO use tmux's 'join-pane' to attach a window or pane from another session.
# write a good interface to select pane/window for this join-pane.


# # Tmux & Screen {{{
# # avoid a possible impact on stability of urxvtd
# # if login_shell, interactive

# #if ! tmux has-session -t Daily; then
#     #exec tmux new-session -s Daily -d
#     ## other setup commands before attaching ...
# #fi
# #exec tmux attach -t Daily

# TMUX_MOD=`[ -z "$TMUX" ] && echo 1`
# TMUX_TERM_LIST=(rxvt-unicode-256color Apple_Terminal iTerm.app)

# _check_term_app() {
#     TP=''
#     if [ -n "$TERM_PROGRAM" ];then
#         TP=$TERM_PROGRAM
#     elif [ -n "$TERM" ]; then
#         TP=$TERM
#     else
#         echo 'Either $TERM or $TERM_PROGRAM is set, cannot determine terimnal name.'
#         return 1
#     fi

#     res=${TMUX_TERM_LIST[@]/${TP}/yes}
#     if [ -n "`echo $res | grep 'yes'`" ]; then
#         return 0
#     else
#         return 1
#     fi
# }

# TIMEOUT=3
# DEFAULT_SESSION=new
# SIGNAL=9
# SELECT_CMD=
# CODE="
# _timeout() {
#     sleep \$1
#     echo \$2
#     kill -\$3 \$4
# }

# _timeout $TIMEOUT $DEFAULT_SESSION $SIGNAL \$\$ &
# SUB_PID=\$!

# SELECT_CMD

# kill -9 \$SUB_PID
# exit
# "

# # Start tmux if no tmux is running under current shell
# if [ "`_check_term_app && echo 1`" = "1" -a "z$TMUX_MOD" = "z1" ];then
#     ## DONE:TODO: If there's no session,create a new one,otherwise show a list for user to select
#     #session_list=(`tmux list-sessions | tr '\n' ','`)
#     session_list=`tmux list-sessions | sed "s/.*/'&'/g" | tr '\n' ' '`
#     if [ -n "$session_list" ];then
#         echo 'Select an session'

#         SELECT_CMD="
#         select session in ${session_list[*]}; do
#             target=\`echo \$session | awk '{print \$1}'\`
#             echo \$target
#             break
#         done
#         "

#         CODE=${CODE/SELECT_CMD/$SELECT_CMD}
#         #echo $CODE > t
#         #echo ------------------------------- >> t
#         target=`bash -c "$CODE"`
#     fi

#     echo target=$target

#     ## Open tmux
#     cmd=tmux
#     if [ -n "$target" -a "$target" != "new" ];then
#         cmd="$cmd attach -t $target"
#     fi
#     eval "$cmd" || echo "Tmux exited abnormally. Exit code $?"
#     exit 0
# fi
# # }}}
