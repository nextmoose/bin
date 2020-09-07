#!/bin/sh

sudo apt-get update --assume-yes &&
    sudo apt-get install --assume-yes pass gnupg gnupg2 git pinentry-qt &&
    sudo apt install --assume-yes raspberrypi-kernel raspberrypi-kernel-headers &&
    curl -sSL https://get.docker.com | sh &&
    sudo usermod -aG docker pi &&
    sudo apt-get install --assume-yes emacs &&
    rm --recursive --force ~/.gnupg ~/.password-store ~/.ssh ~/bin/.git/hooks/post-commit &&
    gpg --batch --import ~/private/gpg-private-keys.asc &&
    gpg --import-ownertrust ~/private/gpg-ownertrust.asc &&
    gpg2 --import ~/private/gpg2-private-keys.asc &&
    gpg2 --import-ownertrust ~/private/gpg2-ownertrust.asc &&
    git -C ~/bin config user.name "Emory Merryman" &&
    git -C ~/bin config user.email "emory.merryman@gmail.com" &&
    git -C ~/bin remote add personal github.com:nextmoose/bin.git &&
    git -C ~/bin fetch personal scratch/47a12c84-f151-11ea-98ff-d3a850417752 &&
    git -C ~/bin checkout scratch/47a12c84-f151-11ea-98ff-d3a850417752 &&
    ( cat > ~/bin/.git/hooks/post-commit <<EOF
#!/bin/sh

while ! git push personal HEAD
do
    sleep 1s &&
        true
done &&
    true
EOF
    ) &&
    chmod 0500 ~/bin/.git/hooks/post-commit &&
    mkdir ~/.password-store &&
    git -C ~/.password-store init &&
    git -C ~/.password-store remote add secrets https://github.com/nextmoose/secrets.git &&
    git -C ~/.password-store fetch secrets scratch/6c2a59d6-f14c-11ea-84d3-f7d8c9c25e5f &&
    git -C ~/.password-store checkout secrets/scratch/6c2a59d6-f14c-11ea-84d3-f7d8c9c25e5f &&
    mkdir ~/.ssh &&
    ( cat > ~/.ssh/config <<EOF
Host self
HostName 127.0.0.1
LocalForward *:2222 127.0.0.1:22
IdentityFile ~/.ssh/id_rsa
ControlMaster auto
ControlPath ~/.ssh/%C.ctrl_path
UserKnownHostsFile ~/.ssh/other.known_hosts

Host github
User git
HostName github.com
IdentityFile ~/.ssh/id_rsa
UserKnownHostsFile ~/.ssh/known_hosts
EOF
    ) &&
    pass show id_rsa > ~/.ssh/id_rsa &&
    pass show known_hosts > ~/.ssh/known_hosts &&
    chmod 0400 ~/.ssh/config ~/.ssh/id_rsa ~/.ssh/known_hosts &&
    ssh-keygen -y -f ~/.ssh/id_rsa > ~/.ssh/authorized_keys &&
    chmod 0400 ~/.ssh/authorized_keys &&
    git -C ~/.password-store remote add personal github:nextmoose/browser-secrets.git &&
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
