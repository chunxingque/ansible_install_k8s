#!/bin/bash

wget https://github.com/kubernetes/ingress-nginx/blob/main/deploy/static/provider/cloud/deploy.yaml
kubectl apply -f deploy.yaml
