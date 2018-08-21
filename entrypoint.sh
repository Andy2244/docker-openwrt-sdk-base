#!/bin/bash

# If GOSU_USER environment variable set to something other than 0:0 (root:root),
# become user:group set within and exec command passed in args
if [ -n "$GOSU_USER" -a "$GOSU_USER" != "0:0" ]; then
	# make sure a valid user exists in /etc/passwd
	if grep "^builder:" /etc/passwd; then
		sed -i "/^builder:/d" /etc/passwd
	fi
	echo "builder:x:$GOSU_USER:OPENWRT builder:/home/openwrt:/bin/bash" >> /etc/passwd
	exec gosu $GOSU_USER "$@"
fi

# If GOSU_USER was 0:0 exec command passed in args without gosu (assume already root)
exec "$@"
