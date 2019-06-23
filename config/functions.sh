#!/bin/bash

function get_docker_image_tag() {
	orig_tag="${1}"
	target="${2}"
	sub_target="${3}"

	echo "${orig_tag}_${target}_${sub_target}"
}
