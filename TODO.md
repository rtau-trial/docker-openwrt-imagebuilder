2. Customize the Docker Hub autobuild process
	1. Build different targets for a single release
	2. Tag them with different image tag
		tag format: :<openwrt release>-<build_no>+<target>
		e.g. v17.01.0-1+x86-64

# Done
1. Make those runtime changing directories volumes
	1. tmp
	2. bin (targets containing the built image)
	3. build_dir (don't know what it is)
