#!/bin/bash
#* 修改镜像地址 *#

# 自动下载
# yum install -y git
# git clone https://github.com/prometheus-operator/kube-prometheus.git
# 手动下载
# unzip kube-prometheus-main.zip
# mv kube-prometheus-main kube-prometheus

cd ./kube-prometheus
cp -r manifests manifests_bak

# 本地代理镜像地址192.168.15.124/proxy->docker.io和192.168.15.124/quay.io->quay.io
# quay.io/prometheus/alertmanager
sed -i 's#quay.io#192.168.15.124/quay.io#g' manifests/alertmanager-alertmanager.yaml
# quay.io/prometheus/blackbox-exporter、jimmidyson/configmap-reload、quay.io/brancz/kube-rbac-proxy
sed -i 's#quay.io#192.168.15.124/quay.io#g' manifests/blackboxExporter-deployment.yaml
sed -i 's#jimmidyson/configmap-reload#192.168.15.124/proxy/jimmidyson/configmap-reload#g' manifests/blackboxExporter-deployment.yaml
# grafana/grafana
sed -i 's#grafana/grafana#192.168.15.124/proxy/grafana/grafana#g' manifests/grafana-deployment.yaml
# registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.9.2(bitnami少了个v)、quay.io/brancz/kube-rbac-proxy
sed -i 's#quay.io#192.168.15.124/quay.io#g' manifests/kubeStateMetrics-deployment.yaml
sed -i 's#registry.k8s.io/kube-state-metrics/kube-state-metrics:v#192.168.15.124/proxy/bitnami/kube-state-metrics:#g' manifests/kubeStateMetrics-deployment.yaml
# quay.io/prometheus/node-exporter、quay.io/brancz/kube-rbac-proxy
sed -i 's#quay.io#192.168.15.124/quay.io#g' manifests/nodeExporter-daemonset.yaml
# quay.io/prometheus/prometheus
sed -i 's#quay.io#192.168.15.124/quay.io#g' manifests/prometheus-prometheus.yaml
# registry.k8s.io/prometheus-adapter/prometheus-adapter
sed -i 's#registry.k8s.io/prometheus-adapter#192.168.15.124/proxy/v5cn#g' manifests/prometheusAdapter-deployment.yaml
# quay.io/prometheus-operator/prometheus-operator、quay.io/brancz/kube-rbac-proxy
sed -i 's#quay.io#192.168.15.124/quay.io#g' manifests/prometheusOperator-deployment.yaml