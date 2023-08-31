#!/bin/bash

helm repo add cilium https://helm.cilium.io/

helm fetch cilium/cilium
tar zxvf cilium-*.tgz
# 更换代理镜像地址,192.168.15.124/quay-io替换quay.io
sed -i "s#quay.io#192.168.15.124\/quay-io#g" ./cilium/values.yaml
# 安装cilium
helm install cilium ./cilium --namespace kube-system
