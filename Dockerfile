FROM alpine
MAINTAINER "Andy Walsh <andy.walsh44+github@gmail.com>"

ENV LANG=C \
	LC_ALL=C
	
# install build packages 
RUN \
	apk add --update --no-cache \
	mc nano \
	intltool perl less bsd-compat-headers curl ca-certificates gnupg \
	asciidoc bash bc binutils bzip2 cdrkit coreutils diffutils findutils flex g++ gawk gcc gettext git grep \
	libxslt linux-headers make ncurses-dev patch python2-dev tar xz unzip util-linux wget zlib-dev && \
	apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
	gosu && \
	rm -rf /var/cache/apk/* && \
	mkdir -p /home/openwrt

RUN git config --global user.email '<>' && \
	git config --global user.name 'Docker Builder'

WORKDIR "/workdir"

COPY entrypoint.sh /usr/local/bin/
RUN chmod 777 /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]

