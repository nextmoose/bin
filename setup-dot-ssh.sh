#!/bin/sh

mkdir ~/.ssh &&
( cat > ~/.ssh/config <<EOF
Host self
HostName 127.0.0.1
LocalForward 127.0.0.1:2222 127.0.0.1:22
EOF
) &&
chmod 0400 ~/.ssh/config &&
true
