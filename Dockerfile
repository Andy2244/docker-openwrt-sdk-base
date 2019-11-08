FROM debian:stretch-slim
MAINTAINER "Andy Walsh <andy.walsh44+github@gmail.com>"

ENV LANG=C.UTF-8

# install build packages 
RUN \
	apt-get update && apt-get install -y \
		mc nano dos2unix bash-completion wget curl procps \
		bc python2.7 python3.5 fastjar flex intltool mercurial cmake genisoimage xsltproc \
		build-essential libncurses5-dev gawk git subversion libssl-dev gettext zlib1g-dev swig unzip time \
	&& rm -rf /var/lib/apt/lists/*

RUN \
	git config --global user.email '<>' && \
	git config --global user.name 'Docker Package Builder'

# add "human" useable texteditor
RUN \
	wget http://www.jbox.dk/downloads/edit.c && \
	gcc -o /usr/local/bin/edit edit.c -Os && \
	chmod +x /usr/local/bin/edit && \
	rm edit.c

# add Tini
ENV TINI_VERSION=v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

COPY .bashrc .inputrc /root/
RUN chmod 644 /root/.bashrc /root/.inputrc

WORKDIR "/workdir"
ENTRYPOINT ["/tini", "--"]
CMD ["/bin/bash"]
