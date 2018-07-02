#!/bin/bash
/bin/dd if=/dev/zero of=/swapfile bs=1024 count=2097152
/sbin/mkswap /swapfile
chmod 600 /swapfile
/sbin/swapon /swapfile
/bin/echo >>/etc/fstab /swapfile swap swap defaults 0 0
