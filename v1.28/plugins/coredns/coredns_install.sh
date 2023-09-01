#!/bin/bash
# coredns安装脚本

# 下载最新的coredns.yaml.sed
# wget https://github.com/coredns/deployment/blob/master/kubernetes/coredns.yaml.sed
alias cp='cp'
cp -f coredns.yaml.sed coredns.yaml
sed -i 's/CLUSTER_DOMAIN REVERSE_CIDRS/cluster.local in-addr.arpa ip6.arpa/g'  coredns.yaml
# 外部dns
sed -i 's/UPSTREAMNAMESERVER/192.168.4.168/g'  coredns.yaml
# service的CLUSTER DNS IP
sed -i 's/CLUSTER_DNS_IP/10.200.0.2/g'  coredns.yaml
# 删除STUBDOMAINS
sed -i 's/STUBDOMAINS//g'  coredns.yaml
# 配置内网coredns镜像地址
sed -i 's/coredns\/coredns/192.168.15.124\/proxy\/coredns\/coredns/g'  coredns.yaml
kubectl apply -f coredns.yaml