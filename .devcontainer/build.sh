#!/bin/bash
set -euo pipefail
set -x

gh auth token | docker login ghcr.io -u "$(gh api user -q .login)" --password-stdin

GRO=$(git remote get-url origin)
ORG=$(dirname ${GRO} | awk -F':' '{ print $2 }')
REPO=$(basename -s .git ${GRO})
DEPS_IMG="ghcr.io/${ORG}/${REPO,,}-deps:latest"

echo "Using: ${DEPS_IMG}"

FALLBACK="ghcr.io/carpentries/workbench-docker:latest"
LOCAL_ALIAS="${REPO,,}:local"

if docker pull "$DEPS_IMG"; then
  docker tag "$DEPS_IMG" "$LOCAL_ALIAS"
else
  echo "Could not pull $DEPS_IMG, falling back to $FALLBACK"
  docker pull "$FALLBACK"
  docker tag "$FALLBACK" "$LOCAL_ALIAS"
fi

export DEVC_IMG=${LOCAL_ALIAS}
devcontainer up
