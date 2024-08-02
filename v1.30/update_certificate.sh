#!/usr/bin/env bash

echo -e "################################### \033[41m update etcd certificate  \033[0m ######################################"
ansible-playbook playbook/k8s_master.yaml --tags cfssl-etcd -i k8s_hosts
ansible-playbook playbook/update_certificate.yaml --tags etcd -i k8s_hosts

echo -e "################################### \033[41m update k8s master certificate  \033[0m #################################"
ansible-playbook playbook/k8s_master.yaml --tags cfssl-k8s -i k8s_hosts
ansible-playbook playbook/update_certificate.yaml --tags k8s-master -i k8s_hosts

echo -e "################################## \033[41m update k8s node certificate  \033[0m ####################################"
ansible-playbook playbook/update_certificate.yaml --tags node_init -i k8s_hosts
ansible-playbook playbook/k8s_node.yaml --tags node_kubeconfig -i k8s_hosts
ansible-playbook playbook/update_certificate.yaml --tags k8s-node -i k8s_hosts

echo -e "################################## \033[41m restart k8s \033[0m #####################################################"
ansible-playbook playbook/update_certificate.yaml --tags k8s-master-restart -i k8s_hosts
ansible-playbook playbook/update_certificate.yaml --tags k8s-node-restart -i k8s_hosts

echo -e "################################## \033[41m restart cni \033[0m #####################################################"
# calico
# kubectl rollout restart Deployment calico-kube-controllers -n kube-system
# kubectl rollout restart DaemonSet calico-node -n kube-system

# cilium
kubectl rollout restart Deployment cilium-operator -n kube-system
kubectl rollout restart DaemonSet cilium -n kube-system
# kubectl rollout restart Deployment hubble-ui -n kube-system

echo -e "################################## \033[41m restart metrics-server \033[0m #############################################"
kubectl rollout restart Deployment metrics-server -n kube-system
