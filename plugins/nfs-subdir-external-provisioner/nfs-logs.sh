#!/bin/bash
# k8s日志挂载到nfs存储
#安装nfs
ansible-playbook -i ../../k8s_hosts nfs_install.yaml

#添加仓库
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
#拉取chart
helm fetch nfs-subdir-external-provisioner/nfs-subdir-external-provisioner

# 安装chart
# 国内镜像地址：registry.cn-hangzhou.aliyuncs.com/lfy_k8s_images/nfs-subdir-external-provisioner:v4.0.2
# chart: nfs-subdir-external-provisioner/nfs-subdir-external-provisioner

helm install nfs-logs  nfs-subdir-external-provisioner-*.tgz \
    --set nfs.server=192.168.15.111 \
    --set nfs.path=/data/logs \
    --set image.repository=192.168.15.124/google_containers/nfs-subdir-external-provisioner \
    --set image.tag=v4.0.2