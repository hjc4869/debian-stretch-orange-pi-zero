# Build Debian 9 SD card image for Orange Pi Zero

To build the image, you need an armhf/arm64 Debian system, and execute

    # For non-ARM system, install qemu-user-static and binfmt-support
    apt install qemu-user-static binfmt-support
    apt install debootstrap
    make MIRROR=http://ftp.us.debian.org/debian/
    
(Replace the url with whatever mirror you want)  

An image with Orange Pi Zero u-boot, Debian 9 rootfs and backport kernel will be created.

The setup process has the following extra steps:

1. DHCP is enabled on eth0.
1. root password is set to 1234.
1. OpenSSH server is installed and enabled with root login allowed.

The following actions are recommended after deploying the image

1. If you download a pre-built image, **re-generate OpenSSH host keys**, especially when you plan to use SSH to connect to the system over public Internet.
1. Resize the partition to fit your SD card

## Daily build
[![Build status](https://dev.azure.com/jingchuan/debian-images/_apis/build/status/Orange%20Pi%20Zero%20daily%20build)](https://dev.azure.com/jingchuan/debian-images/_build/latest?definitionId=2)

Check on GitHub release page and [Azure DevOps](https://dev.azure.com/jingchuan/debian-images/_build/index?definitionId=2)
