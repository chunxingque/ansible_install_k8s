#!/usr/bin/env bash
KUBE_APISERVER="https://127.0.0.1:6443"

# kube-controller-manager
kubectl config set-cluster kubernetes \
    --certificate-authority=../generate_files/ca.pem \
    --embed-certs=true \
    --server=${KUBE_APISERVER} \
    --kubeconfig=kube-controller-manager.kubeconfig

kubectl config set-credentials system:kube-controller-manager \
    --client-certificate=../generate_files/kube-controller-manager.pem \
    --client-key=../generate_files/kube-controller-manager-key.pem \
    --embed-certs=true \
    --kubeconfig=kube-controller-manager.kubeconfig

kubectl config set-context default \
    --cluster=kubernetes \
    --user=system:kube-controller-manager \
    --kubeconfig=kube-controller-manager.kubeconfig

kubectl config use-context default --kubeconfig=kube-controller-manager.kubeconfig
mv -f kube-controller-manager.kubeconfig ../generate_files/

# kube-scheduler
kubectl config set-cluster kubernetes \
    --certificate-authority=../generate_files/ca.pem \
    --embed-certs=true \
    --server=${KUBE_APISERVER} \
    --kubeconfig=kube-scheduler.kubeconfig

kubectl config set-credentials system:kube-scheduler \
    --client-certificate=../generate_files/kube-scheduler.pem \
    --client-key=../generate_files/kube-scheduler-key.pem \
    --embed-certs=true \
    --kubeconfig=kube-scheduler.kubeconfig

kubectl config set-context default \
    --cluster=kubernetes \
    --user=system:kube-scheduler \
    --kubeconfig=kube-scheduler.kubeconfig

kubectl config use-context default --kubeconfig=kube-scheduler.kubeconfig
mv -f kube-scheduler.kubeconfig ../generate_files/

# kubectl
kubectl config set-cluster kubernetes \
    --certificate-authority=../generate_files/ca.pem \
    --embed-certs=true \
    --server="$KUBE_APISERVER" \
    --kubeconfig=admin.kubeconfig

kubectl config set-credentials admin \
    --client-certificate=../generate_files/admin.pem \
    --client-key=../generate_files/admin-key.pem \
    --embed-certs=true \
    --kubeconfig=admin.kubeconfig

kubectl config set-context default \
    --cluster=kubernetes \
    --user=admin \
    --kubeconfig=admin.kubeconfig

kubectl config use-context default --kubeconfig=admin.kubeconfig
mv -f admin.kubeconfig ../generate_files/

