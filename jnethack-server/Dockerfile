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
ENV JNETHACK_URL=https://ja.osdn.net/dl/jnethack/jnethack-3.6.6-0.6.diff.gz

WORKDIR /tmp

COPY ./patch/jnethack_server.patch /tmp/

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
	ca-certificates \
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
 && sh ./configure \
 && make all \
 && make install


#------------------------------------------------------------------------------
# gotty-build
#------------------------------------------------------------------------------
FROM debian:bullseye AS gotty-build

ARG HTTP_PROXY

ENV http_proxy=${HTTP_PROXY}
ENV https_proxy=${HTTP_PROXY}
ENV DEBIAN_FRONTEND=noninteractive
ENV GOPATH /tmp/go

WORKDIR /tmp

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
	ca-certificates \
	golang \
	git \
 && mkdir go \
 && cd go \
 && go get github.com/yudai/gotty


#------------------------------------------------------------------------------
# target image
#------------------------------------------------------------------------------
FROM debian:bullseye-slim

ARG HTTP_PROXY

COPY --from=gotty-build   /tmp/go/bin/gotty /usr/local/bin/
COPY --from=nethack-build /nh366/           /nh366/
COPY ./entrypoint.sh  /

RUN export http_proxy=${HTTP_PROXY} \
 && export DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
	libncursesw6 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && chown -R games:games /nh366/ \
 && mv /nh366/var /nh366/var.orig

WORKDIR /nh366

EXPOSE 8080

VOLUME ["/nh366/var"]

ENTRYPOINT ["/entrypoint.sh"]
CMD ["jnethack"]
