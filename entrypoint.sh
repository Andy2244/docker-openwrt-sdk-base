#!/bin/sh

endchar="\$"
if [ "$UID" = "0" ]; then
	endchar="#"
fi

# Blue
BG="\[\e[38;5;39m\]"
# RGBA index:
#BG="\[\e[38;2;255;142;58m\]"

# Orange
FG="\[\e[38;5;208m\]"
# RGBA index:
#FG="\[\e[38;2;0;174;255m\]"

#PS1='🐳  \[\033[1;36m\]\h \[\033[1;34m\]\W\[\033[0;35m\] \[\033[1;36m\]# \[\033[0m\]'

export PS1="🐳  $BG\u\[\e[0m\]@$FG\H ${BG}\w ${BG}$endchar \[\e[0;0m\]"
if [ "${TERM:0:5}" = "xterm" ]; then
	export PS1="\[\e]2;\u@\H :: \w\a\]$PS1"
fi
#####################################################

chown -R $GOSU_USER /home/openwrt

# If GOSU_USER environment variable set to something other than 0:0 (root:root),
# become user:group set within and exec command passed in args
if [ "$GOSU_USER" != "0:0" ]; then
	# make sure a valid user exists in /etc/passwd
	if grep "^builder:" /etc/passwd; then
		sed -i "/^builder:/d" /etc/passwd
	fi
	echo "builder:x:$GOSU_USER:OPENWRT builder:/home/openwrt:/bin/bash" >> /etc/passwd
	exec gosu $GOSU_USER "$@"
fi

# If GOSU_USER was 0:0 exec command passed in args without gosu (assume already root)
exec "$@"
