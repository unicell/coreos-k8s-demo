#!/bin/bash
. environments

NUM_OF_DROPLETS=2
NAME_PREFIX=tcore0

for i in `seq $NUM_OF_DROPLETS`; do ./boot_coreos.sh $NAME_PREFIX$i; done

:> allhosts
for i in `seq $NUM_OF_DROPLETS`; do tugboat info $NAME_PREFIX$i | grep IP | awk '{print $2}' >>allhosts; done
# fab set_hosts bootstrap

:> ~/.fleetctl/known_hosts

# pushd ./bin
# for h in `cat allhosts`; do
    # tar -czf - . | ssh core@$h "sudo mkdir -p /opt/bin; cd /opt/bin; sudo tar xzvf -"
# done
# popd
fab -P deploy_binaries
