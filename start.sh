#!/bin/sh
set -e

ls -l /etc/git-secret/ssh
gitSecret="/etc/git-secret/ssh"
if [ -f "$gitSecret" ]; then
    chmod 400 "$gitSecret"
    chown $(id -u):$(id -g) "$gitSecret"
fi
ls -l /etc/git-secret
if [ -d "/git" ]; then
    rm -rf /git/*
fi

/git-sync "$@"
