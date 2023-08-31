#!/usr/bin/env bash

# ETCD集群健康检查
etcdctl member list --write-out=table
etcdctl endpoint health --write-out=table

# apiserver和kube-controller-manager健康检查
kubectl get cs