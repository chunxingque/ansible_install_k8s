#!/usr/bin/env bash

set -e
echo -e "######################## \033[41m localhost unzip k8s binary_package \033[0m ##############################"
ansible-playbook playbook/k8s_master.yaml --tags unzip_package -i k8s_hosts
echo -e "######################## \033[41m master install helm & kubectl & cfssl \033[0m ##############################"
ansible-playbook playbook/k8s_master.yaml --tags k8s_command -i k8s_hosts
echo -e "################################### \033[41m generate certificate \033[0m ####################################"
ansible-playbook playbook/k8s_master.yaml --tags cfssl-etcd -i k8s_hosts
ansible-playbook playbook/k8s_master.yaml --tags cfssl-k8s -i k8s_hosts
echo -e "####################################### \033[41m install etcd \033[0m ########################################"
ansible-playbook playbook/k8s_master.yaml --tags etcd -i k8s_hosts
echo -e "################################## \033[41m install kube-apiserver \033[0m ###################################"
ansible-playbook playbook/k8s_master.yaml --tags kube-apiserver -i k8s_hosts
echo -e "################################ \033[41m copy kubectl kubeconfig \033[0m ################################"
ansible-playbook playbook/k8s_master.yaml --tags kubectl -i k8s_hosts
echo -e "##################################### \033[41m install haproxy \033[0m #######################################"
ansible-playbook playbook/k8s_master.yaml --tags haproxy -i k8s_hosts
echo -e "#################################### \033[41m install keepalived \033[0m #####################################"
ansible-playbook playbook/k8s_master.yaml --tags keepalived -i k8s_hosts
echo -e "############################## \033[41m install kube-controller-manager \033[0m ##############################"
ansible-playbook playbook/k8s_master.yaml --tags kube-controller-manager -i k8s_hosts
echo -e "################################## \033[41m install kube-scheduler \033[0m ###################################"
ansible-playbook playbook/k8s_master.yaml --tags kube-scheduler -i k8s_hosts

