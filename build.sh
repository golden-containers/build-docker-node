#!/bin/sh

set -xe
rm -rf working
mkdir working
cd working

# Checkout upstream

git clone --depth 1 --branch main https://github.com/nodejs/docker-node.git
cd docker-node

# TODO: Enumerate Node versions in repo to be transformed/built/pushed

# Transform

sed -i -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/debian\:bullseye/; t" -e "1,// s//FROM ghcr.io\/golden-containers\/debian\:bullseye/" 17/bullseye/Dockerfile
sed -i -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/debian\:bullseye-slim/; t" -e "1,// s//FROM ghcr.io\/golden-containers\/debian\:bullseye-slim/" 17/bullseye-slim/Dockerfile

# Build

docker build --tag ghcr.io/golden-containers/node:17-bullseye-slim 17/bullseye-slim

# Push

docker push ghcr.io/golden-containers/node -a
