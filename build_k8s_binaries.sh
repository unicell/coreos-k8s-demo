#!/bin/bash

# Steps from
# https://github.com/kelseyhightower/kubernetes-coreos/blob/master/docs/build.md

pushd ~
git clone https://github.com/unicell/kubernetes-coreos.git
cd kubernetes-coreos
docker build --no-cache -t unicell/kubernetes-binaries:latest .
popd

mkdir -p ./bin
docker run --name kubernetes-binaries unicell/kubernetes-binaries:latest /bin/sh
docker cp kubernetes-binaries:/kubernetes-binaries .
cp kubernetes-binaries/* ./bin
docker rm kubernetes-binaries
