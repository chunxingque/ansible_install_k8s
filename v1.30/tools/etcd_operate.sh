#!/bin/bash
echo -e "#################################### \033[41m  etcd update ssl  \033[0m ####################################"
ansible-playbook playbook/etcd_operate.yaml --tags etcd_ssl -i k8s_hosts
ansible-playbook playbook/etcd_operate.yaml --tags apiserver_ssl -i k8s_hosts