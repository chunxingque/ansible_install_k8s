#!/bin/bash
# coredns安装脚本

# 下载指定版本的calico.yaml
# wget https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/calico.yaml
alias cp='cp'
cp -f calico.yaml calico_modify.yaml
# 修改CALICO_IPV4POOL_CIDR
sed -i 's/\# - name: CALICO_IPV4POOL_CIDR/- name: CALICO_IPV4POOL_CIDR/g' calico_modify.yaml
sed -i 's/\#   value: "192.168.0.0\/16"/  value: "10.100.0.0\/16"/g'  calico_modify.yaml
# 添加网卡
sed -i 's#docker.io\/calico\/node#192.168.15.124\/proxy\/calico\/node#g'  calico_modify.yaml

# 配置内网calico镜像地址
sed -i 's#docker.io\/calico\/kube-controllers#192.168.15.124\/proxy\/calico\/kube-controllers#g'  calico_modify.yaml
sed -i 's#docker.io\/calico\/cni#192.168.15.124\/proxy\/calico\/cni#g'  calico_modify.yaml
sed -i 's#docker.io\/calico\/node#192.168.15.124\/proxy\/calico\/node#g'  calico_modify.yaml
kubectl apply -f calico_modify.yaml