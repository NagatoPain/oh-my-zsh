# Push and pop directories on directory stack
alias pu='pushd'
alias po='popd'

# Basic directory operations
alias ...='cd ../..'
alias ..='cd ..'
alias ..2='cd ../..'
alias ..3='cd ../../..'
alias ..4='cd ../../../..'
alias -- -='cd -'

# Super user
alias _='sudo'

# Grep
#alias g='grep -in'
#alias grep.ack='ack-grep -il'

# Show history
alias history='fc -l 1'

# List direcory contents
alias l='ls++'
alias ll='ls -l'
alias lsa='ls -lah'
# alias ls='ls --color=always -N -B -h -F'
# alias pwd='pwd -P' # use '-P' option to avoid symbol links.
alias subdir='ls -F | grep /$' # list out all subdirectories.

# Verbose File manipulation
alias rm='rm -i -v'
# alias mv='mv -v -i -b -S".bak" -u'
# alias cp='cp -i -b -S".bak" -u -v --recursive'
alias mv='mv -i -b'
alias cp='cp -i -b -R -H'
alias chattr='chattr -V'
alias rename='rename -v'
alias rmdir='rmdir -v'
alias mkdir='mkdir -v'
alias eject='eject -v'

# Disk manipulation
alias df='df -a -h -T'

# Process
alias ps_visual='ps aux --forest | sort -nk +4 | tail'
alias ps_tops='ps aux | sort -nrk +4 | head'

# Admin
alias chmod='chmod -c'
alias chown='chown -c'
alias chgrp='chgrp -c'
