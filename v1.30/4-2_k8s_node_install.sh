#!/usr/bin/env bash
set -e
echo -e "###################################### \033[42m modify kubelet token  \033[0m ######################################"
/bin/sh ./sh/modify_token.sh
echo -e "###################################### \033[42m generate node kubeconfig  \033[0m ######################################"
ansible-playbook playbook/k8s_node.yaml --tags node_kubeconfig -i k8s_hosts

echo -e "###################################### \033[42m master install kubelet \033[0m ######################################"
ansible-playbook playbook/k8s_node.yaml --tags master-kubelet -i k8s_hosts
echo -e "#################################### \033[42m master install kube-proxy \033[0m ####################################"
ansible-playbook playbook/k8s_node.yaml --tags master-kube-proxy -i k8s_hosts

echo -e "###################################### \033[42m node install kubelet \033[0m ######################################"
ansible-playbook playbook/k8s_node.yaml --tags node-kubelet -i k8s_hosts
echo -e "###################################### \033[42m node install kube-proxy \033[0m ######################################"
ansible-playbook playbook/k8s_node.yaml --tags node-kube-proxy -i k8s_hosts
