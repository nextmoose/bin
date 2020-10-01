#!/bin/sh

WORK_DIR=$( mktemp -d ) &&
    sudo apt-get update --assume-yes &&
    sudo apt-get install --assume-yes tar gzip gnupg gnupg2 git pinentry-qt genisoimage dvdisaster fuseiso rsync s3fs awscli &&
    s3fs "${1}" "${WORK_DIR}" &&
    rsync --archive --delete --progress --progress --executability "${2}" "${WORK_DIR}/private" &&
    tar --verbose --create --file "${WORK_DIR}/private.tar" --directory "${WORK_DIR}/private" . &&
    gzip -9 --to-stdout "${WORK_DIR}/private.tar" > "${WORK_DIR}/private.tar.gz" &&
    gpg --output "${WORK_DIR}/private.tar.gz.gpg" --encrypt --sign --recipient "Emory Merryman" "${WORK_DIR}/private.tar.gz" &&
    genisoimage -r -o "${WORK_DIR}/private.tar.gz.gpg.iso" "${WORK_DIR}/private.tar.gz.gpg" &&
    dvdisaster --image "${WORK_DIR}/private.tar.gz.gpg.iso" --ecc "${WORK_DIR}/private.tar.gz.gpg.iso.ecc" --create &&
    mkdir "${WORK_DIR}/temp" &&
    sh "$( dirname "${0}" )/remote-decrypt.sh" "${WORK_DIR}/private.tar.gz.gpg.iso" "${WORK_DIR}/private.tar.gz.gpg.iso.ecc" "${WORK_DIR}/temp" "${WORK_DIR}/verification" &&
    diff -qrs "${WORK_DIR}/private" "${WORK_DIR}/verification" &&
    rm --recursive --force "${WORK_DIR}/private" "${WORK_DIR}/private.tar" "${WORK_DIR}/private.tar.gz" "${WORK_DIR}/private.tar.gz.gpg" "${WORK_DIR}/temp" "${WORK_DIR}/verification" &&
    sudo umount "${WORK_DIR}" &&
    true
