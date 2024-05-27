#!/bin/bash
# 添加仓库
helm repo add  ingress-nginx https://kubernetes.github.io/ingress-nginx

# 拉取到本地
helm fetch ingress-nginx/ingress-nginx
# 无外网可直接下载到本地
# wget https://github.com/kubernetes/ingress-nginx/releases/download/helm-chart-4.7.1/ingress-nginx-4.7.1.tgz

#解压
# tar zxvf ingress-nginx-*.tgz

# 部署ingress-nginx,配置镜像地址
# registry: registry.cn-hangzhou.aliyuncs.com或者代理仓库
# charts： ingress-nginx/ingress-nginx或者ingress-nginx-*.tgz
helm upgrade --install ingress-nginx ingress-nginx-*.tgz  \
  --namespace ingress-nginx --create-namespace \
  -f values_v2.yaml
