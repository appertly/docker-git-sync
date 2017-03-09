#!/bin/sh
#set -e

echo id -u
ls -l /etc/git-secret/ssh

gitSecret="/etc/git-secret/ssh"
if [ -f "$gitSecret" ]; then
    chmod 400 "$gitSecret"
    chown $(id -u):$(id -g) "$gitSecret"
fi

/git-sync "$@"
