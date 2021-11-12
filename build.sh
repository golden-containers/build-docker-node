#!/bin/bash

set -Eeuxo pipefail
rm -rf working
mkdir working
cd working

GCI_URL="ghcr.io/golden-containers"

# Checkout upstream

git clone --depth 1 --branch main https://github.com/nodejs/docker-node.git
cd docker-node

# TODO: Enumerate Node versions in repo to be transformed/built/pushed

# Transform

GCI_REGEX_URL=$(echo ${GCI_URL} | sed 's/\//\\\//g')

# This sed syntax is GNU sed specific
[ -z $(command -v gsed) ] && GNU_SED=sed || GNU_SED=gsed

${GNU_SED}  -i \
    -e "1 s/FROM.*/FROM ${GCI_REGEX_URL}\/buildpack-deps\:bullseye/; t" \
    -e "1,// s//FROM ${GCI_REGEX_URL}\/buildpack-deps\:bullseye/" \
    17/bullseye/Dockerfile

${GNU_SED} -i \
    -e "1 s/FROM.*/FROM ${GCI_REGEX_URL}\/debian\:bullseye-slim/; t" \
    -e "1,// s//FROM ${GCI_REGEX_URL}\/debian\:bullseye-slim/" \
    17/bullseye-slim/Dockerfile

# Build

[ -z "${1:-}" ] && BUILD_LABEL_ARG="" || BUILD_LABEL_ARG=" --label \"${1}\" "

BUILD_PLATFORM=" --platform linux/amd64 "
BUILD_ARGS=" ${BUILD_LABEL_ARG} ${BUILD_PLATFORM} "

docker build 17/bullseye/ ${BUILD_ARGS} \
    --tag ${GCI_URL}/node:17-bullseye

docker build 17/bullseye-slim/ ${BUILD_ARGS} \
    --tag ${GCI_URL}/node:17-bullseye-slim
    
# Push

docker push ${GCI_URL}/node -a
