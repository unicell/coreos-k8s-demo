#!/bin/bash
sed -i -e 's/${COREOS_PRIVATE_IPV4}/'"$COREOS_PRIVATE_IPV4"'/g' $1
