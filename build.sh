#!/bin/bash

set -Eeuxo pipefail
rm -rf working
mkdir working
cd working

# Checkout upstream

git clone --depth 1 --branch main https://github.com/nodejs/docker-node.git
cd docker-node

# TODO: Enumerate Node versions in repo to be transformed/built/pushed

# Transform

# This sed syntax is GNU sed specific
[ -z $(command -v gsed) ] && GNU_SED=sed || GNU_SED=gsed

${GNU_SED}  -i \
    -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/buildpack-deps\:bullseye/; t" \
    -e "1,// s//FROM ghcr.io\/golden-containers\/buildpack-deps\:bullseye/" \
    17/bullseye/Dockerfile

${GNU_SED} -i \
    -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/debian\:bullseye-slim/; t" \
    -e "1,// s//FROM ghcr.io\/golden-containers\/debian\:bullseye-slim/" \
    17/bullseye-slim/Dockerfile

# Build

[ -z "${1:-}" ] && BUILD_LABEL_ARG="" || BUILD_LABEL_ARG=" --label \"${1}\" "

BUILD_PLATFORM=" --platform linux/amd64 "
GCI_URL="ghcr.io/golden-containers"
BUILD_ARGS=" ${BUILD_LABEL_ARG} ${BUILD_PLATFORM} "

docker build 17/bullseye/ --tag ${GCI_URL}/node:17-bullseye ${BUILD_ARGS}
docker build 17/bullseye-slim/ --tag ${GCI_URL}/node:17-bullseye-slim ${BUILD_ARGS}

# Push

docker push ${GCI_URL}/node -a
