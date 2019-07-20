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

ARG OPENWRT_RELEASE=17.01.0
ARG OPENWRT_TARGET=x86
ARG OPENWRT_SUBTARGET=64
ARG OPENWRT_BASEDIR=/opt/openwrt/

RUN useradd -u 10000 openwrt \
 && mkdir -p \
   "${OPENWRT_BASEDIR}builder_bin" \
   "${OPENWRT_BASEDIR}builder_tmp" \
 && chown -R 10000 "${OPENWRT_BASEDIR}"

VOLUME "${OPENWRT_BASEDIR}builder_bin" "${OPENWRT_BASEDIR}builder_tmp" 

ARG OPENWRT_FILENAME=lede-imagebuilder-${OPENWRT_RELEASE}-${OPENWRT_TARGET}-${OPENWRT_SUBTARGET}.Linux-x86_64
ARG OPENWRT_TARGET_BASE=releases/${OPENWRT_RELEASE}/targets
ARG OPENWRT_IB_URL="https://downloads.openwrt.org/${OPENWRT_TARGET_BASE}/${OPENWRT_TARGET}/${OPENWRT_SUBTARGET}/${OPENWRT_FILENAME}.tar.xz"

RUN wget --progress=bar:force -S -O- ${OPENWRT_IB_URL} | tar -Jxf- -C ${OPENWRT_BASEDIR}

WORKDIR "${OPENWRT_BASEDIR}/${OPENWRT_FILENAME}/"
VOLUME "${OPENWRT_BASEDIR}/${OPENWRT_FILENAME}/build_dir"

## Cache the downloaded packages to install by default
RUN ln -Ts "${OPENWRT_BASEDIR}/builder_bin" "${OPENWRT_BASEDIR}/${OPENWRT_FILENAME}/bin" \
 && ln -Ts "${OPENWRT_BASEDIR}/builder_tmp" "${OPENWRT_BASEDIR}/${OPENWRT_FILENAME}/tmp"
# TODO: Find out how to cache the download package with less resource usage
# && make image

ARG VCS_REF=Unknown
LABEL 	org.label-schema.vcs-ref=${VCS_REF} \
	org.label-schema.vcs-url="https://github.com/rtau-trial/docker-openwrt-imagebuilder" \
	org.opencontainers.image.revision=${VCS_REF} \
	org.opencontainers.image.source="https://github.com/rtau-trial/docker-openwrt-imagebuilder"

