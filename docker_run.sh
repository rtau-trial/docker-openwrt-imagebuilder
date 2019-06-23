#!/bin/bash

ARG_BIN_DIR="${1}"

if [[ -d "${ARG_BIN_DIR}" ]]
then
	BIN_DIR="${ARG_BIN_DIR}"
	shift
else
	BIN_DIR="${PWD}/builder_bin"
fi

docker run -it -v "${BIN_DIR}:/opt/openwrt/builder_bin" "${@}"
