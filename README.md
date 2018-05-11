# Build Debian 9 SD card image for Orange Pi Zero

To build the image, you need an armhf/arm64 Debian system, and execute

    make MIRROR=http://ftp.us.debian.org/debian/
    
(Replace the url with whatever mirror you want)  

An image with Orange Pi Zero u-boot (u-boot-sunxi-with-spl.bin binary is from Debian Buster `u-boot-sunxi` package), Debian 9 rootfs and backport kernel will be created.

The setup process has the following extra steps:

1. DHCP is enabled on eth0.
1. root password is set to 1234.
1. OpenSSH server is installed and enabled with root login allowed.
