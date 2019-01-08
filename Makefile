MIRROR ?= http://ftp.us.debian.org/debian/

all:
	make image
	make debootstrap
	make prepare
	make setup
	make cleanup
	make firmware-install

image:
	fallocate -l 4G ./image
	/sbin/sfdisk ./image < partitions
	mkdir -p ./root
	sudo losetup -o 10485760 --sizelimit 4194304000 /dev/loop1 image
	sudo mkfs.ext4 -L root -U 84a32ad9-0701-4fcc-8d37-5589451a86b2 /dev/loop1
	sudo mount /dev/loop1 ./root

debootstrap:
ifneq (,$(filter $(shell uname -m),arm aarch64))
	sudo debootstrap --arch armhf stretch root $(MIRROR)
else
	sudo debootstrap --foreign --arch armhf stretch root $(MIRROR)
	sudo cp $(shell which qemu-arm-static) root/usr/bin
	sudo chroot root/ /debootstrap/debootstrap --second-stage
endif

prepare:
	echo "deb $(MIRROR) stretch main non-free contrib\ndeb $(MIRROR) stretch-backports main non-free contrib" | sudo tee ./root/etc/apt/sources.list
	sudo cp modules ./root/etc/modules
	sudo cp fstab ./root/etc/fstab
	sudo cp eth0 ./root/etc/network/interfaces.d/
	sudo mkdir -p ./root/proc/device-tree/
	sudo cp model ./root/proc/device-tree/
	sudo cp flash-kernel-db ./root/flash-kernel-db
	sudo cp flash-kernel-cfg ./root/flash-kernel-cfg

setup:
	sudo cp install ./root/install
	sudo chroot ./root ./install
	sudo rm ./root/install
	sudo rm -f ./root/usr/bin/qemu-arm-static
	cp ./root/usr/lib/u-boot/orangepi_zero/u-boot-sunxi-with-spl.bin ./

cleanup:
	sync
	sudo umount ./root || true
	sudo losetup -d /dev/loop1 || true

firmware-install:
	dd if=./u-boot-sunxi-with-spl.bin of=./image bs=1k seek=8 oflag=sync conv=notrunc
	rm ./u-boot-sunxi-with-spl.bin

clean:
	make cleanup
	sudo rm -rf ./root
	sudo rm -rf ./image
