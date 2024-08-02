#!/bin/bash
cd ./kube-prometheus
sed -i 's/UTC/CST/g' manifests/grafana-config.yaml
sed -i 's/UTC/CST/g' manifests/grafana-dashboardDefinitions.yaml

kubectl apply -f manifests/grafana-config.yaml
kubectl apply -f manifests/grafana-dashboardDefinitions.yaml
