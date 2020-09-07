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
    echo ENTER THE WRONG PASSWORD &&
    gpgconf --reload gpg-agent &&
    ! sh "$( dirname "${0}" )/decrypt.sh" "${WORK_DIR}/private.tar.gz.gpg.iso" "${WORK_DIR}/private.tar.gz.gpg.iso.ecc" "${WORK_DIR}/verification" &&
    gpgconf --reload gpg-agent &&
    sh "$( dirname "${0}" )/decrypt.sh" "${WORK_DIR}/private.tar.gz.gpg.iso" "${WORK_DIR}/private.tar.gz.gpg.iso.ecc" "${WORK_DIR}/verification" &&
    diff -qrs "${WORK_DIR}/private" "${WORK_DIR}/verification" &&
    sed -e "s#AA#BB#" -e "w${WORK_DIR}/corruption-01.iso" "${WORK_DIR}/private.tar.gz.gpg.iso" | grep "AA" | wc --lines | cut --fields 1 --delimiter " " &&
    sh "$( dirname "${0}" )/decrypt.sh" "${WORK_DIR}/corruption-01.iso" "${WORK_DIR}/private.tar.gz.gpg.iso.ecc" "${WORK_DIR}/corruption-01" &&
    diff -qrs "${WORK_DIR}/private" "${WORK_DIR}/corruption-01" &&
    sed -e "s#A#B#" -e "w${WORK_DIR}/corruption-02.iso" "${WORK_DIR}/private.tar.gz.gpg.iso" | grep "AA" | wc --lines | cut --fields 1 --delimiter " " &&
    echo TOO MUCH CORRUPTION &&
    ! sh "$( dirname "${0}" )/decrypt.sh" "${WORK_DIR}/corruption-02.iso" "${WORK_DIR}/private.tar.gz.gpg.iso.ecc" "${WORK_DIR}/corruption-02" &&
    echo "${WORK_DIR}" &&
    true
