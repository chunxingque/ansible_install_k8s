#!/bin/bash
# k8s数据挂载nfs存储
#安装nfs
ansible-playbook -i ../../k8s_hosts nfs_install.yaml

#添加仓库
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
#拉取chart
# helm fetch nfs-subdir-external-provisioner/nfs-subdir-external-provisioner

# 安装chart
# 国内镜像地址：registry.cn-hangzhou.aliyuncs.com/lfy_k8s_images/nfs-subdir-external-provisioner:v4.0.2
# chart: nfs-subdir-external-provisioner/nfs-subdir-external-provisioner

helm install nfs-subdir-external-provisioner  nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set nfs.server=192.168.15.111 \
    --set nfs.path=/data \
    --set image.repository=192.168.15.124/google_containers/nfs-subdir-external-provisioner \
    --set image.tag=v4.0.2