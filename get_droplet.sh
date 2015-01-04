#!/bin/bash

if [ -n "$1" ]; then
    DROPLET_ID=$1
else
    DROPLET_ID=""
fi

curl -X GET "https://api.digitalocean.com/v2/droplets/$DROPLET_ID" \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer $DO_TOKEN"
