#!/bin/bash
set -e

gitSecret="/root/.ssh/id_rsa"
if [ -n "$GIT_SYNC_PRIVATE_KEY" ]; then
    mkdir -p /root/.ssh
    echo $GIT_SYNC_PRIVATE_KEY > "$gitSecret"
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

if [ -d "$groot" ]; then
    find "$groot" -mindepth 1 -delete
fi

# var flWait = flag.Float64("wait", envFloat("GIT_SYNC_WAIT", 0),
# 	"the number of seconds between syncs")
# var flOneTime = flag.Bool("one-time", envBool("GIT_SYNC_ONE_TIME", false),
# 	"exit after the initial checkout")
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
if [ "$gmod" != "0" ]; then
    chmod -R $gmod $groot
fi
if [ -n "$gchown" ]; then
    chown -R $gchown $groot
fi
if [ -n "$gchgrp" ]; then
    chgrp -R $gchgrp $groot
fi

while true
do
	sleep 30
done
