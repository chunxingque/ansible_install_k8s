#!/usr/bin/env bash

echo -e "###################################### \033[41m uninstall k8s \033[0m ######################################"
ansible -i ../k8s_hosts master -m shell -a "systemctl stop kube-apiserver kube-controller-manager kube-scheduler kubelet kube-proxy"
ansible -i ../k8s_hosts node -m shell -a "kubelet kube-proxy"
ansible -i ../k8s_hosts master -m shell -a "rm -f /usr/lib/systemd/system/{etcd.service,kube-apiserver.service,kube-controller-manager.service,kube-scheduler.service,kubelet.service,kube-proxy.service}"
ansible -i ../k8s_hosts master -m shell -a "rm -f /usr/lib/systemd/system/{kube-scheduler.service,kubelet.service,kube-proxy.service}"

ansible -i ../k8s_hosts master:node -m shell -a "rm -rf /etc/kubernetes/"
ansible -i ../k8s_hosts master:node -m shell -a "rm -f /usr/local/bin/kube-*"
ansible -i ../k8s_hosts master:node -m shell -a "sed -i "/k8s/d" /etc/hosts"

echo -e "###################################### \033[41m uninstall etcd \033[0m ######################################"
ansible -i ../k8s_hosts etcd -m shell -a "systemctl stop etcd"
ansible -i ../k8s_hosts etcd -m shell -a "rm -rf /usr/lib/systemd/system/etcd.service"
ansible -i ../k8s_hosts etcd -m shell -a "rm -f /usr/local/bin/etcd*"
ansible -i ../k8s_hosts etcd -m shell -a "rm -rf /var/lib/etcd"
ansible -i ../k8s_hosts etcd -m shell -a "rm -rf /etc/etcd"

echo -e "###################################### \033[41m uninstall containerd \033[0m ######################################"
ansible -i ../k8s_hosts master:node -m shell -a "systemctl stop containerd"
ansible -i ../k8s_hosts master:node -m shell -a "rm -f /usr/local/bin/containerd*"
ansible -i ../k8s_hosts master:node -m shell -a "rm -rf /etc/cni"
ansible -i ../k8s_hosts master:node -m shell -a "rm -rf /etc/containerd"
ansible -i ../k8s_hosts master:node -m shell -a "rm -rf /opt/cni"
