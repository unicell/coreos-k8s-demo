#!/bin/bash
mkdir -p ./bin
docker pull tomlanyon/flannel-install
docker run --rm -v $PWD/bin:/host tomlanyon/flannel-install
