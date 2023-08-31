#!/usr/bin/env bash
# author:que
# date:2023-07-08


echo -e "##################################### \033[41m unarchive k8s Binary files \033[0m #######################################"
ansible-playbook playbook/k8s_update.yaml -i k8s_hosts --tags unarchive
echo -e "##################################### \033[41m update master k8s Binary files \033[0m #######################################"
ansible-playbook playbook/k8s_update.yaml -i k8s_hosts --tags master_k8s_update
echo -e "##################################### \033[41m update node k8s Binary files \033[0m #######################################"
ansible-playbook playbook/k8s_update.yaml -i k8s_hosts --tags node_k8s_update
echo -e "##################################### \033[41m restart k8s Binary files \033[0m #######################################"
ansible all -m shell -a "systemctl restart kube-apiserver kube-controller-manager kube-scheduler kubelet kube-proxy flanneld etcd"
ansible all -m shell -a "systemctl restart docker"
echo "更新完成！"