#!/bin/sh

set -xe

rm -rf docker-node
git clone --depth 1 --branch main https://github.com/nodejs/docker-node.git
cd docker-node

sed -i -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/bullseye-slim/; t" -e "1,// s//FROM ghcr.io\/golden-containers\/bullseye-slim/" 17/bullseye/Dockerfile
sed -i -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/bullseye-slim/; t" -e "1,// s//FROM ghcr.io\/golden-containers\/bullseye-slim/" 17/bullseye-slim/Dockerfile
#sed -i -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/bullseye/; t" -e "1,// s//FROM ghcr.io\/golden-containers\/bullseye/" debian/bullseye/curl/Dockerfile
#sed -i -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/bullseye-curl/; t" -e "1,// s//FROM ghcr.io\/golden-containers\/bullseye-curl/" debian/bullseye/scm/Dockerfile
#sed -i -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/bullseye-scm/; t" -e "1,// s//FROM ghcr.io\/golden-containers\/bullseye-scm/" debian/bullseye/Dockerfile


