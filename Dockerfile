FROM ubuntu:18.04

## NOTE: Do not run on release
## RUN sed -i 's!http://archive.ubuntu.com/ubuntu/!mirror://mirrors.ubuntu.com/mirrors.txt!' /etc/apt/sources.list

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install \
		--auto-remove \
		--yes \
		build-essential \
		gawk \
		gettext \
		git \
		libncurses5-dev \
		libssl-dev \
		python \
		unzip \
		wget \
		xsltproc \
		zlib1g-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ARG OPENWRT_RELEASE=18.06.2
ARG OPENWRT_TARGET=x86
ARG OPENWRT_SUBTARGET=64
ARG OPENWRT_BASEDIR=/opt/openwrt/

RUN useradd -u 10000 openwrt \
 && mkdir "${OPENWRT_BASEDIR}" \
 && chown 10000 "${OPENWRT_BASEDIR}"

USER openwrt

WORKDIR ${OPENWRT_BASEDIR}
RUN wget -q -O- https://downloads.openwrt.org/releases/"${OPENWRT_RELEASE}/targets/${OPENWRT_TARGET}/${OPENWRT_SUBTARGET}/openwrt-imagebuilder-${OPENWRT_RELEASE}-${OPENWRT_TARGET}-${OPENWRT_SUBTARGET}.Linux-x86_64.tar.xz" | tar -Jxf-

WORKDIR "${OPENWRT_BASEDIR}/openwrt-imagebuilder-${OPENWRT_RELEASE}-${OPENWRT_TARGET}-${OPENWRT_SUBTARGET}.Linux-x86_64/"

# Cache the downloaded packages to install by default
RUN make image \
 && rm -fR bin