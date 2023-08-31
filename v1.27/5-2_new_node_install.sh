#!/usr/bin/env bash

set -e
echo -e "###################################### \033[41m node install kubelet \033[0m ######################################"
ansible-playbook playbook/add_node.yaml --tags kubelet -i k8s_hosts
echo -e "###################################### \033[41m node install kube-proxy \033[0m ######################################"
ansible-playbook playbook/add_node.yaml --tags kube-proxy -i k8s_hosts
