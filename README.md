# docker-git-sync
A better Git synchronization sidecar container.

## Environment Variables

We use a lot of the same environment variables that the Kubernetes git-sync container does

* `GIT_SYNC_REPO` – The URL for the Git repository.
* `GIT_SYNC_BRANCH` – The branch to clone. `master` by default.
* `GIT_SYNC_DEPTH` – The history depth to pull (by default, unspecified).
* `GIT_SYNC_ROOT` – The directory into which the repository will be cloned (`/git` by default).
* `GIT_SYNC_PERMISSIONS` – Any cloned files will be `chmod`ed to this
* `GIT_SYNC_SSH` – Whether we should use SSH (false by default).
* `GIT_SYNC_WAIT` – The number of seconds to wait between pulls (`30` by default).
* `GIT_SYNC_ONE_TIME` – Whether we should clone once and never pull again.
* `GIT_SYNC_USERNAME` – The auth username to use.
* `GIT_SYNC_PASSWORD` – The auth password to use.

Plus we add a couple more.

* `GIT_SYNC_CHOWN` – Any cloned files will be `chown`ed to this
* `GIT_SYNC_CHGRP` – Any cloned files will be `chgrp`ed to this

## SSH Keys

You can provide SSH keys to the container in one of two ways.

1. You can mount it at `/root/.ssh/id_rsa` with a mode of 400.
2. You can provide it in the environment variable `GIT_SYNC_PRIVATE_KEY` and it will be written to the proper location.
