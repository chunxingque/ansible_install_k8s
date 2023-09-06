#!/bin/bash

#** services修改类型为Nodeport **#
sed -i '/spec:/a \ \ type:\ NodePort'  manifests/prometheus-service.yaml
sed -i '/spec:/a \ \ type:\ NodePort' manifests/grafana-service.yaml
sed -i '/spec:/a \ \ type:\ NodePort' manifests/alertmanager-service.yaml
sed -i '/spec:/a \ \ type:\ NodePort' manifests/blackboxExporter-service.yaml

#** 提交修改 **#
kubectl apply -f manifests/prometheus-service.yaml
kubectl apply -f manifests/grafana-service.yaml
kubectl apply -f manifests/alertmanager-service.yaml
kubectl apply -f manifests/blackboxExporter-service.yaml

#** 获取NodePort端口 **#
kubectl get svc -n monitoring |grep NodePort