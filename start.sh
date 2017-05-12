#!/bin/bash
set -e

gitSecret="/root/.ssh/id_rsa"
mkdir -p /root/.ssh
if [ -n "$GIT_SYNC_PRIVATE_KEY" ]; then
    echo "$GIT_SYNC_PRIVATE_KEY" > "$gitSecret"
fi
if [ -f "$gitSecret" ]; then
    chmod 400 "$gitSecret"
    chown $(id -u):$(id -g) "$gitSecret"
fi

if [ -z "$GIT_SYNC_REPO" ]; then
    echo "No git repository specified in GIT_SYNC_REPO"
    exit 1
fi
grepo="$GIT_SYNC_REPO"
gbranch="${GIT_SYNC_BRANCH:-master}"
gdepth="${GIT_SYNC_DEPTH:-0}"
groot="${GIT_SYNC_ROOT:-/git}"
gmod="${GIT_SYNC_PERMISSIONS:-0}"
gssh="$GIT_SYNC_SSH"
gchown="$GIT_SYNC_CHOWN"
gchgrp="$GIT_SYNC_CHGRP"
gusername="$GIT_SYNC_USERNAME"
gpassword="$GIT_SYNC_PASSWORD"
gwait="${GIT_SYNC_WAIT:-30}"
gonce="${GIT_SYNC_ONE_TIME}"
gafter="${GIT_SYNC_POST_PULL}"

if [ -d "$groot" ]; then
    find "$groot" -mindepth 1 -delete
fi

# var flMaxSyncFailures = flag.Int("max-sync-failures", envInt("GIT_SYNC_MAX_SYNC_FAILURES", 0),
# 	"the number of consecutive failures allowed before aborting (the first pull must succeed)")

if [ -n "$gssh" ]; then
    echo -e "Host *\n\tStrictHostKeyChecking no\n\tUserKnownHostsFile /dev/null\n" >> ~/.ssh/config
fi
if [ -n "$gusername" ] && [ -n "$gpassword" ]; then
    git config --global credential.helper cache
    echo "url=$grepo\nusername=$gusername\npassword=$gpassword\n" | git credential approve
fi

gitcmd="git clone $grepo --branch $gbranch --single-branch "
if [ "$gdepth" != "0" ]; then
    gitcmd="$gitcmd --depth $gdepth"
fi
gitcmd="$gitcmd $groot"

eval "$gitcmd"

doChanges()
{
    if [ "$gmod" != "0" ]; then
        chmod -R $gmod $groot
    fi
    if [ -n "$gchown" ]; then
        chown -R $gchown $groot
    fi
    if [ -n "$gchgrp" ]; then
        chgrp -R $gchgrp $groot
    fi
    if [ -n "$gafter" ]; then
        eval "$gafter"
    fi
}
cd $groot
doChanges

if [ -z "$gonce" ]; then
    while true
    do
	    sleep $gwait
        git pull
        doChanges
    done
else
    while true
    do
        sleep 30
    done
fi
