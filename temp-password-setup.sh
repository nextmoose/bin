#!/bin/sh

export WORK_DIR=$( mktemp -d ) &&
    cleanup(){
	rm --recursive --force ${WORK_DIR} &&
	    true
    } &&
    trap cleanup EXIT &&
    export PASSWORD_STORE_DIR=${WORK_DIR}/password-store &&
    export GNUPGHOME=${WORK_DIR}/gpg &&
    export PASSWORD_STORE_GPG_OPTS="--homedir ${GNUPGHOME}" &&
    mkdir ${PASSWORD_STORE_DIR} ${GNUPGHOME} &&
    chmod 0700 ${GNUPGHOME} &&
    echo AAAA &&
    gpg --homedir ${GNUPGHOME} --batch --import ${HOME}/private/gpg-private-keys.asc &&
    echo AAAA &&
    gpg --homedir ${GNUPGHOME} --import-ownertrust ${HOME}/private/gpg-ownertrust.asc &&
    echo BBBB &&
#    gpg --homedir ${GNUPGHOME} --update-trustdb &&
    echo CCCC &&
    gpg2 --homedir ${GNUPGHOME} --import ${HOME}/private/gpg-private-keys.asc &&
    gpg2 --homedir ${GNUPGHOME} --import-ownertrust ${HOME}/private/gpg-ownertrust.asc &&
#    gpg2 --homedir ${GNUPGHOME} --update-trustdb &&
    git -C ${PASSWORD_STORE_DIR} init &&
    git -C ${PASSWORD_STORE_DIR} remote add personal github:nextmoose/secrets.git &&
#    export LONG_KEY=$( gpg --keyid-format LONG -k "Emory Merryman" ) &&
    bash &&
    echo ZZZZ &&
    true
