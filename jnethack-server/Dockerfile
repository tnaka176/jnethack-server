# vim: set tabstop=8 noexpandtab softtabstop=0 shiftwidth=0 :

#------------------------------------------------------------------------------
# nethack-build
#------------------------------------------------------------------------------
FROM debian:bullseye AS nethack-build

ARG HTTP_PROXY

ENV http_proxy=${HTTP_PROXY}
ENV https_proxy=${HTTP_PROXY}
ENV DEBIAN_FRONTEND=noninteractive
ENV NETHACK_URL=https://www.nethack.org/download/3.6.6/nethack-366-src.tgz
ENV JNETHACK_URL=https://ja.osdn.net/dl/jnethack/jnethack-3.6.6-0.5.diff.gz

WORKDIR /tmp

COPY ./patch/jnethack_server.patch /tmp/

RUN apt-get update \
 && apt-get install -y \
	build-essential \
	bison \
	flex \
	bsdextrautils \
	libncurses5-dev \
	gzip \
	curl \
	nkf \
	groff-base \
 && mkdir nethack-src \
 && curl -sL ${NETHACK_URL} | tar zxf - -C nethack-src --strip-components 1 \
 && cd nethack-src \
 && curl -sL ${JNETHACK_URL} | zcat - | patch -p1 \
 && cat ../jnethack_server.patch | patch -p1 \
 && find . -type f | xargs -i nkf -e -Lu --overwrite {} \
 && cd sys/unix \
 && sh setup.sh hints/linux \
 && cd ../../ \
 && make all \
 && make install


#------------------------------------------------------------------------------
# dgamelaunch-build
#------------------------------------------------------------------------------
FROM debian:bullseye AS dgamelaunch-build

ARG HTTP_PROXY

ENV http_proxy=${HTTP_PROXY}
ENV https_proxy=${HTTP_PROXY}
ENV DEBIAN_FRONTEND=noninteractive
ENV DGAMELAUNCH_URL=https://github.com/paxed/dgamelaunch.git

WORKDIR /tmp

COPY ./patch/dgamelaunch_343-366.patch /tmp/

RUN apt-get update \
 && apt-get install -y \
	build-essential \
	autoconf \
	bison \
	flex \
	git \
	libncurses5-dev \
	libsqlite3-dev \
	sqlite3 \
 && git clone ${DGAMELAUNCH_URL} \
 && cd dgamelaunch \
 && cat ../dgamelaunch_343-366.patch | patch -p1 \
 && ./autogen.sh \
	--enable-sqlite \
	--enable-shmem \
	--with-config-file=/home/nethack/etc/dgamelaunch.conf \
 && make \
 && ./dgl-create-chroot \
 && rm -fr /home/nethack/nh366/ \
 && cp /lib/x86_64-linux-gnu/libncursesw.so.6 /home/nethack/lib/x86_64-linux-gnu/


#------------------------------------------------------------------------------
# target image
#------------------------------------------------------------------------------
FROM debian:bullseye-slim

ARG HTTP_PROXY

COPY --from=dgamelaunch-build /home/nethack/ /home/nethack/
COPY --from=nethack-build     /nh366/        /home/nethack/nh366/
COPY ./xinetd-dgl     /etc/xinetd.d/dgl
COPY ./entrypoint.sh  /

RUN export http_proxy=${HTTP_PROXY} \
 && export DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get install -y \
	flex \
	xinetd \
	telnetd \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && chown -R games:games /home/nethack/nh366/ \
 && mv /home/nethack/dgldir    /home/nethack/dgldir.orig \
 && mv /home/nethack/nh366/var /home/nethack/nh366/var.orig

WORKDIR /home/nethack

EXPOSE 23

VOLUME ["/home/nethack/dgldir", "/home/nethack/nh366/var"]

ENTRYPOINT ["/entrypoint.sh"]
CMD ["xinetd", "-dontfork"]
