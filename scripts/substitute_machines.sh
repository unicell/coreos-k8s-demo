#!/bin/bash
MACHINES=`fleetctl list-machines | tail -n +2 | awk '{print $2}' | paste -d, -s`
sed -i -e 's/${MACHINES}/'"$MACHINES"'/g' $1
