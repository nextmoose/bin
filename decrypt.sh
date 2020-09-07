#!/bin/sh

sudo apt-get update --assume-yes &&
    sudo apt-get install --assume-yes tar gzip gnupg gnupg2 git pinentry-qt genisoimage dvdisaster fuseiso &&
    sudo modprobe fuse &&
    sudo addgroup fuse &&
    sudo adduser $(whoami) fuse &&
    cd $( mktemp -d ) &&
    cp "${1}" private.tar.gz.gpg.iso &&
    if ! dvdisaster --image private.tar.gz.gpg.iso --ecc "${2}" --test
    then
	dvdisaster --image private.tar.gz.gpg.iso --ecc "${2}" --fix &&
	    true
    fi &&
    echo fuseiso -p $(pwd)/private.tar.gz.gpg.iso mount -f &&
    fuseiso -p private.tar.gz.gpg.iso mount -f &&
    echo gpg --output private.tar.gz --decrypt mount/private.tar.gz.gpg &&
    gpg --output private.tar.gz --decrypt mount/private.tar.gz.gpg &&
    umount mount &&
    gunzip --to-stdout private.tar.gz > private.tar &&
    tar --extract --file private.tar &&
    true
