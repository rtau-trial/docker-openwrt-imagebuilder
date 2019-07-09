FROM ubuntu:18.04

## NOTE: Use mirror site for package download. Uncomment in case download is slow
# RUN sed -i 's!http://archive.ubuntu.com/ubuntu/!mirror://mirrors.ubuntu.com/mirrors.txt!' /etc/apt/sources.list

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

ARG OPENWRT_RELEASE=18.06.4
ARG OPENWRT_TARGET=x86
ARG OPENWRT_SUBTARGET=64
ARG OPENWRT_FILENAME=openwrt-imagebuilder-${OPENWRT_RELEASE}-${OPENWRT_TARGET}-${OPENWRT_SUBTARGET}.Linux-x86_64
ARG OPENWRT_BASEDIR=/opt/openwrt/

RUN useradd -u 10000 openwrt \
 && mkdir -p \
   "${OPENWRT_BASEDIR}builder_bin" \
   "${OPENWRT_BASEDIR}builder_tmp" \
 && chown -R 10000 "${OPENWRT_BASEDIR}"

VOLUME "${OPENWRT_BASEDIR}builder_bin" "${OPENWRT_BASEDIR}builder_tmp" 

RUN wget --progress=bar:force -S -O- "https://downloads.openwrt.org/releases/${OPENWRT_RELEASE}/targets/${OPENWRT_TARGET}/${OPENWRT_SUBTARGET}/${OPENWRT_FILENAME}.tar.xz" | tar -Jxf- -C ${OPENWRT_BASEDIR}

WORKDIR "${OPENWRT_BASEDIR}/${OPENWRT_FILENAME}/"
VOLUME "${OPENWRT_BASEDIR}/${OPENWRT_FILENAME}/build_dir"

## Cache the downloaded packages to install by default
RUN ln -Ts "${OPENWRT_BASEDIR}/builder_bin" "${OPENWRT_BASEDIR}/${OPENWRT_FILENAME}/bin" \
 && ln -Ts "${OPENWRT_BASEDIR}/builder_tmp" "${OPENWRT_BASEDIR}/${OPENWRT_FILENAME}/tmp" \
# TODO: Find out how to cache the download package with less resource usage
# && make image
