#!/bin/bash
set -x
. environments

NUM_OF_DROPLETS=2
NAME_PREFIX=tcore0

for i in `seq $NUM_OF_DROPLETS`; do ./create_droplet.sh $NAME_PREFIX$i; done

# update host list for fabric use
:> allhosts
for i in `seq $NUM_OF_DROPLETS`; do
    DROPLET_STATUS="new"
    DROPLET_DETAILS=""
    while [ "$DROPLET_STATUS" != "active" ]; do
        sleep 15
        DROPLET_DETAILS=`./get_droplet.sh | jq '.droplets[] | select(.name == '\""$NAME_PREFIX$i"\"')'`
        DROPLET_STATUS=`echo $DROPLET_DETAILS | jq '.status' | sed 's/"//g'`
    done
    PUBLIC_IP=`echo $DROPLET_DETAILS | jq '.networks.v4 | .[] | select(.type =="public") | .ip_address' | sed 's/"//g'`
    echo $PUBLIC_IP >>allhosts;
done

# cleanup known hosts lists
:> ~/.fleetctl/known_hosts
for h in `cat allhosts`; do ssh-keygen -f "$HOME/.ssh/known_hosts" -R $h; done

# wait another 2 minutes to make sure Droplets able to be sshed
sleep 120
fab set_hosts deploy_minion
fab -H `head -1 allhosts` deploy_master
