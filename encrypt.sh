#!/bin/sh

WORK_DIR=$( mktemp -d ) &&
    sudo apt-get update --assume-yes &&
    sudo apt-get install --assume-yes tar gzip gnupg gnupg2 git pinentry-qt genisoimage dvdisaster fuseiso &&
    cp --recursive "${@}" "${WORK_DIR}/private" &&
    tar --verbose --create --file "${WORK_DIR}/private.tar" --directory "${WORK_DIR}/private" . &&
    gzip -9 --to-stdout "${WORK_DIR}/private.tar" > "${WORK_DIR}/private.tar.gz" &&
    gpg --output "${WORK_DIR}/private.tar.gz.gpg" --armor --symmetric "${WORK_DIR}/private.tar.gz" &&
    genisoimage -r -o "${WORK_DIR}/private.tar.gz.gpg.iso" "${WORK_DIR}/private.tar.gz.gpg" &&
    dvdisaster --image "${WORK_DIR}/private.tar.gz.gpg.iso" --ecc "${WORK_DIR}/private.tar.gz.gpg.iso.ecc" --create &&
    gpgconf --reload gpg-agent &&
    sh "$( dirname "${0}" )/decrypt.sh" "${WORK_DIR}/private.tar.gz.gpg.iso" "${WORK_DIR}/private.tar.gz.gpg.iso.ecc" "${WORK_DIR}/verification" &&
    diff -qrs "${WORK_DIR}/private" "${WORK_DIR}/verification" &&
    echo "${WORK_DIR}" &&
    true
