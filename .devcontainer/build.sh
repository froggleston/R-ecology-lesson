#!/bin/bash
set -euo pipefail
set -x

GRO=$(git remote get-url origin)
ORG=$(dirname ${GRO} | awk -F':' '{ print $2 }')
REPO=$(basename -s .git ${GRO})
DEPS_IMG="ghcr.io/${ORG}/${REPO,,}-deps:latest"

echo "Using: ${DEPS_IMG}"

if docker pull "$DEPS_IMG"; then
  # update the Dockerfile FROM
  sed -i "s|^FROM .*|FROM $DEPS_IMG|" Dockerfile
fi

devcontainer up
