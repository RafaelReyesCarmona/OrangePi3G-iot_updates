#!/bin/bash
DEST=/home/orangepi/OrangePi3G-iot/output/rootfs
do_chroot() {
	# Add qemu emulation
        cp /usr/bin/qemu-arm-static "$DEST/usr/bin"

	cmd="$@"

 	# if [[ ! -f /proc/sys/fs/binfmt_misc/arm ]]; then
		# echo ':arm:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/usr/bin/qemu-arm-static:CF' > /proc/sys/fs/binfmt_misc/register
	# fi
	chroot "/home/orangepi/OrangePi3G-iot/output/rootfs" mount -t proc proc /proc || true
	chroot "/home/orangepi/OrangePi3G-iot/output/rootfs" mount -t sysfs sys /sys || true
	chroot "/home/orangepi/OrangePi3G-iot/output/rootfs" $cmd
	chroot "/home/orangepi/OrangePi3G-iot/output/rootfs" umount /sys
	chroot "/home/orangepi/OrangePi3G-iot/output/rootfs" umount /proc

	# echo -1 > /proc/sys/fs/binfmt_misc/arm

	# Clean up
	rm -f "/home/orangepi/OrangePi3G-iot/output/rootfs/usr/bin/qemu-arm-static"
}


	cp ./updates/Python-3.7.9-compiled_arm.tar.gz ./output/rootfs/usr/local/src
	cd ./output/rootfs/usr/local/src
	tar -xvf Python-3.7.9-compiled_arm.tar.gz
	cat > "/home/orangepi/OrangePi3G-iot/output/rootfs/update-phase" <<EOF
#!/bin/bash
cd /usr/local/src/Python-3.7.9
apt-get install checkinstall
checkinstall -D make altinstall
EOF
	chmod +x "/home/orangepi/OrangePi3G-iot/output/rootfs/update-phase"
	do_chroot /update-phase
	rm -f "/home/orangepi/OrangePi3G-iot/output/rootfs/update-phase"
