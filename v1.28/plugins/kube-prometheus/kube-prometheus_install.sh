#!/bin/bash
# 自动下载
# yum install -y git
# git clone https://github.com/prometheus-operator/kube-prometheus.git
# 手动下载
# unzip kube-prometheus-main.zip
# mv kube-prometheus-main kube-prometheus

# 安装
cd ./kube-prometheus
kubectl apply --server-side -f manifests/setup
kubectl wait \
    --for condition=Established \
    --all CustomResourceDefinition \
    --namespace=monitoring
kubectl apply -f manifests/


