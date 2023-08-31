#!/usr/bin/env bash
set -e
echo -e "###################################### \033[41m modify kubelet token  \033[0m ######################################"
/usr/bin/sh ./modify_token.sh
echo -e "###################################### \033[41m generate node kubeconfig  \033[0m ######################################"
ansible-playbook playbook/k8s_node.yaml --tags node_kubeconfig -i k8s_hosts

echo -e "###################################### \033[41m master install kubelet \033[0m ######################################"
ansible-playbook playbook/k8s_node.yaml --tags master-kubelet -i k8s_hosts
echo -e "#################################### \033[41m master install kube-proxy \033[0m ####################################"
ansible-playbook playbook/k8s_node.yaml --tags master-kube-proxy -i k8s_hosts

echo -e "###################################### \033[41m node install kubelet \033[0m ######################################"
ansible-playbook playbook/k8s_node.yaml --tags node-kubelet -i k8s_hosts
echo -e "###################################### \033[41m node install kube-proxy \033[0m ######################################"
ansible-playbook playbook/k8s_node.yaml --tags node-kube-proxy -i k8s_hosts

# 检查是否自动加入集群
# kubectl get nodes
# 检查master组件是否有报错
# tail -200f /var/log/messages
# systemctl status kubelet -l