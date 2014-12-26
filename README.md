# Quick Start 

./bootstrap.sh

./build_flannel.sh
./build_k8s_binaries.sh

fab -P set_hosts deploy_binaries deploy_common_services
fab -H <master IP> deploy_master
