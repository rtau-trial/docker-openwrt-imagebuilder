# Unofficial OpenWrt Image Builder Docker image

This image is based on Ubuntu 18.04 LTS, with the packages required to run OpenWrt imagebuilder installed and the imagebuilder included.

## Usage
Simply run the Docker image, you will be in the directory with OpenWrt Image builder installed.

```
docker run -it rtau/openwrt-imagebuilder
```

In the container started, you are free to run whatever commands as documented in https://openwrt.org/docs/guide-user/additional-software/imagebuilder

### Access images built outside container
The `bin` directory of imagebuilder is symbolic link to the directory `/opt/openwrt/builder_bin`, which you may bind it to a volume on the host 
to keep the images built. 

The script `docker_run.sh` is included to start the container with the directory binded to `builder_bin` on the current directory.

## Image Variants
The images are tagged in the following format:
`rtau/openwrt-imagebuilder:v<openwrt release>_<target>_<subtarget>`

For example, release 18.06.4, target x86, subtarget generic: `v18.06.4_x86_generic`
