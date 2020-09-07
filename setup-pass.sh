#!/bin/sh

sudo apt-get update --assume-yes &&
    sudo apt-get install --assume-yes pass gnupg gnupg2 git pinentry-qt &&
    rm --recursive --force ~/.ssh ~/private ~/.password-store &&
    scp -r "${@}:private" . &&
    scp -r "${@}:.ssh" . &&
    gpg --batch --import ~/private/gpg-private-keys.asc &&
    gpg --import-ownertrust ~/private/gpg-ownertrust.asc &&
    gpg2 --import ~/private/gpg2-private-keys.asc &&
    gpg2 --import-ownertrust ~/private/gpg2-ownertrust.asc &&
    mkdir ~/.password-store &&
    git -C ~/.password-store init &&
    git -C ~/.password-store remote add personal git@github.com:nextmoose/browser-secrets.git &&
    git -C ~/.password-store fetch personal master &&
    git -C ~/.password-store checkout master &&
    git -C ~/.password-store config user.name "Emory Merryman" &&
    git -C ~/.password-store config user.email "emory.merryman@gmail.com" &&
    (cat > ~/.password-store/.git/hooks/post-commit <<EOF
#!/bin/sh

while ! git push personal HEAD
do
    sleep 1s &&
    true
done &&
true
EOF
    ) &&
    chmod 0500 ~/.password-store/.git/hooks/post-commit &&
    true
