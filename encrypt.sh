#!/bin/sh

WORK_DIR=$( mktemp -d ) &&
    sudo apt-get update --assume-yes &&
    sudo apt-get install --assume-yes tar gzip gnupg gnupg2 git pinentry-qt genisoimage dvdisaster fuseiso &&
    cd "${WORK_DIR}" &&
    mkdir encryption verification &&
    cd encryption &&
    cp --recursive "${@}" private &&
    tar --verbose --create --file private.tar private &&
    gzip -9 --to-stdout private.tar > private.tar.gz &&
    gpg --output private.tar.gz.gpg --armor --symmetric private.tar.gz &&
    genisoimage -o private.tar.gz.gpg.iso private.tar.gz.gpg &&
    dvdisaster --image private.tar.gz.gpg.iso --ecc private.tar.gz.gpg.iso.ecc --create &&
    cd "${WORK_DIR}/verification" &&
    dvdisaster --mage "${WORK_DIR}/encryption/private.tar.gz.gpg.iso" --ecc "${WORK_DIR}/encryption/private.tar.gz.gpg.iso.ecc" --test &&
    sudo modprobe fuse &&
    if ! groups | grep fuse
    then
	sudo addgroup fuse &&
	    sudo adduser $(whoami) fuse &&
	    true
    fi &&
    su --command "fuseiso -p \"${WORK_DIR}/encryption/private.tar.gz.gpg.iso\" mount" "$( whoami )" &&
    gpg --output private.tar.gz --decrypt mount/private.tar.gz.gpg &&
    umount mount &&
    gunzip --to-stdout private.tar.gz > private.tar &&
    tar --verbose --extract --file private.tar &&
    diff --qrs "${WORK_DIR}/encryption/private" private &&
    echo "${WORK_DIR}" &&
    true
