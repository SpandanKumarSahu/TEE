FROM ubuntu:16.04

ENV HTTP_PROXY "http://172.16.2.30:8080"
ENV HTTPS_PROXY "http://172.16.2.30:8080"
ENV http_proxy "http://172.16.2.30:8080"
ENV https_proxy "http://172.16.2.30:8080"
ENV HTTP_PROXY=http://172.16.2.30:8080
ENV HTTPS_PROXY=http://172.16.2.30:8080
ENV http_proxy=http://172.16.2.30:8080
ENV https_proxy=http://172.16.2.30:8080
ENV NO_PROXY "127.0.0.1, localhost"

RUN apt-get update
RUN apt-get install -y android-tools-adb android-tools-fastboot autoconf \
	automake bc bison build-essential cscope curl device-tree-compiler flex \
	ftp-upload gdisk iasl libattr1-dev libcap-dev libfdt-dev \
	libftdi-dev libglib2.0-dev libhidapi-dev libncurses5-dev \
	libpixman-1-dev libssl-dev libstdc++6 libtool libz1 make \
	mtools netcat python-crypto python-serial python-wand unzip uuid-dev \
	xdg-utils xterm xz-utils zlib1g-dev libdb1-compat tzdata initscripts
RUN apt-get install -y ccache
RUN apt-get install -y gcc-arm*
RUN mkdir ~/bin
RUN PATH=~/bin:$PATH

RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /bin/repo
RUN chmod a+x /bin/repo
RUN mkdir -p $HOME/devel/optee
WORKDIR $HOME/devel/optee

RUN apt-get install -y git
RUN git config --global user.name "Spandan Kumar Sahu"
RUN git config --global user.email "spandankumarsahu@gmail.com"
RUN git config --global http.proxy "http://172.16.2.30:8080"
RUN git config --global https.proxy "http://172.16.2.30:8080"
RUN repo init -u https://github.com/OP-TEE/manifest.git -m rpi3.xml
RUN repo sync -j3

RUN cd build
RUN make toolchains -j3

RUN make all
RUN make update_rootfs
