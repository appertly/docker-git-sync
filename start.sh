#!/bin/sh
set -e

gitSecret="/etc/git-secret/ssh"
if [ -n "$GIT_SYNC_PRIVATE_KEY" ]; then
    mkdir -p /etc/git-secret
    echo $GIT_SYNC_PRIVATE_KEY > "$gitSecret"
fi

if [ -f "$gitSecret" ]; then
    chmod 400 "$gitSecret"
    chown $(id -u):$(id -g) "$gitSecret"
fi
ls -la /etc/git-secret
if [ -d "/git" ]; then
    rm -rf /git/*
fi

/git-sync "$@"
