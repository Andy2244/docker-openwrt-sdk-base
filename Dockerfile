FROM alpine:3.8
MAINTAINER "Andy Walsh <andy.walsh44+github@gmail.com>"

ENV LANG=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8 \
	LC_CTYPE=en_US.UTF-8 \
	LC_ALL=en_US.UTF-8

# install build packages 
RUN \
	apk add --update --no-cache \
	mc nano lzo lz4 dos2unix bash-completion htop tzdata \
	intltool perl less bsd-compat-headers curl ca-certificates gnupg \
	asciidoc bash bc binutils bzip2 cdrkit coreutils diffutils findutils flex g++ gawk gcc gettext git grep \
	libxslt linux-headers make ncurses-dev patch python2-dev tar xz unzip util-linux wget zlib-dev && \
	apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing gosu && \
	apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community portablexdr-dev && \
	rm -rf /var/cache/apk/*

RUN git config --global user.email '<>' && \
	git config --global user.name 'Docker Package Builder'

# "human" useable texteditor
RUN \
	wget http://www.jbox.dk/downloads/edit.c && \
	gcc -o /usr/local/bin/edit edit.c -Os && \
	chmod 777 /usr/local/bin/edit && \
	rm edit.c

WORKDIR "/workdir"

COPY entrypoint.sh /usr/local/bin/
COPY .bashrc .inputrc /root/
RUN \
	mkdir -p -m 776 /home/openwrt && \
	cp /root/.bashrc /root/.inputrc /home/openwrt/ && \
	sed -e 's~:/bin/ash$~:/bin/bash~' -i /etc/passwd && \
	chmod 777 /usr/local/bin/entrypoint.sh && \
	chmod 644 /root/.bashrc /root/.inputrc && \
	chmod 664 /home/openwrt/.bashrc /home/openwrt/.inputrc

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]
