#!/bin/sh

sudo apt-get update --assume-yes &&
    sudo apt-get install --assume-yes tar gzip gnupg gnupg2 git pinentry-qt genisoimage dvdisaster &&
    cd "${3}" &&
    cp "${1}" private.tar.gz.gpg.iso &&
    dvdisaster --image private.tar.gz.gpg.iso --ecc "${2}" --fix &&
    mkdir mount &&
    sudo mount private.tar.gz.gpg.iso mount &&
    gpg --output private.tar.gz --decrypt mount/private.tar.gz.gpg &&
    sudo umount mount &&
    gunzip --to-stdout private.tar.gz > private.tar &&
    mkdir "${4}" &&
    tar --extract --file private.tar --directory "${4}" &&
    true
