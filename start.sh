#!/bin/sh
set -e

gitSecret="/etc/git-secret/ssh"
if [ -f "$gitSecret" ]; then
    chmod 400 "$gitSecret"
    chown $(id -u):$(id -g) "$gitSecret"
fi
if [ -d "/git" ]; then
    rm -rf /git/*
fi

/git-sync "$@"
