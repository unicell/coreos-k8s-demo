# Quick Start 

## build binaries

    $ ./build_flannel.sh
    $ ./build_k8s_binaries.sh

## start CoreOS cluster (2 nodes) and deploy Kubernetes

Run following command will create 2 nodes on Digital Ocean, upload prebuilt
binaries in previous step, and configure systemd services for Kubernetes.

The number of nodes can be configured in bootstrap.sh, and the first node will
be named as tcore01 and selected as master by default.

    $ ./bootstrap.sh

## ready to use

Log into master server and verify minion list

    $ kubecfg list minions
