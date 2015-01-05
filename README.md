# Quick Start 

## environment dependencies

Scripts in this repo use [jq](stedolan.github.io/jq/) to parse JSON data from
Digital Ocean's API response. If not yet installed, please run following
command.

    $ cd ~/bin && wget http://stedolan.github.io/jq/download/linux64/jq && chmod a+x jq

Also using [Fabric](http://www.fabfile.org/) for Kubernetes deployment.

    $ sudo pip install Fabric

## build binaries

    $ git clone https://github.com/unicell/coreos-k8s-demo.git
    $ cd coreos-k8s-demo
    $ ./build_flannel.sh
    $ ./build_k8s_binaries.sh

## start CoreOS cluster and deploy Kubernetes

Run following bootstrap.sh script will create 2 nodes cluster by default on
Digital Ocean, upload prebuilt binaries in previous step, and configure systemd
services for Kubernetes. Use following env variable to control number of nodes
to be created.

    $ export NUM_OF_DROPLETS=<number of nodes>

You will need to update ssh key settings to your own in create_droplet.sh.
Region, image, size can also be configured in the same file.  The number of
nodes can be configured in bootstrap.sh, and the first node will
be named as tcore01 and selected as master by default.

    $ cd coreos-k8s-demo
    $ ./bootstrap.sh

## ready to use

Log into master server and verify minion list

    $ kubecfg list minions
