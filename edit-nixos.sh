#!/bin/sh

cd "$( mktemp -d )" &&
    teardown ( ) {
	.git/hooks/post-commit &&
	    rm --recursive --force . &&
	    true
    } &&
    trap teardown EXIT &&
    git init &&
    git config user.name "Emory Merryman" &&
    git config user.email "emory.merryman@gmail.com" &&
    git remote add personal git@github.com:nextmoose/nix.git &&
    git fetch personal &&
    git checkout master &&
    ( cat > .git/hooks/post-commit <<EOF
#!/bin/sh

while ! git push personal HEAD
do
    sleep 1s &&
        true
done &&
    true
EOF
    ) &&
    chmod 0500 .git/hooks/post-commit &&
    emacs . &&
    true
