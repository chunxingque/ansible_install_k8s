#!/usr/bin/env bash
config_path="../files"
generate_files_path="../generate_files"

if [ ! -d $generate_files_path ]; then
    mkdir -p $generate_files_path
fi

cd $generate_files_path

# k8s ca
cfssl gencert -initca ${config_path}/ca-csr.json | cfssljson -bare ca -

# kube-apiserver
cfssl gencert \
   -ca=ca.pem \
   -ca-key=ca-key.pem \
   -config=${config_path}/ca-config.json \
   -profile=kubernetes \
   kube-apiserver-csr.json | cfssljson -bare kube-apiserver

# kube-apiserver and kube-controller-manager ServiceAccountKey
openssl genrsa -out sa.key 2048
openssl rsa -in sa.key -pubout -out sa.pub

# kube-controller-manager
cfssl gencert \
   -ca=ca.pem \
   -ca-key=ca-key.pem \
   -config=${config_path}/ca-config.json \
   -profile=kubernetes \
   ${config_path}/kube-controller-manager-csr.json | cfssljson -bare kube-controller-manager

# kube-scheduler
cfssl gencert \
   -ca=ca.pem \
   -ca-key=ca-key.pem \
   -config=${config_path}/ca-config.json \
   -profile=kubernetes \
   ${config_path}/kube-scheduler-csr.json | cfssljson -bare kube-scheduler


# kubectl
cfssl gencert \
   -ca=ca.pem \
   -ca-key=ca-key.pem \
   -config=${config_path}/ca-config.json \
   -profile=kubernetes \
   ${config_path}/admin-csr.json | cfssljson -bare admin

# front-proxy-client
cfssl gencert -initca ${config_path}/front-proxy-ca-csr.json | cfssljson -bare front-proxy-ca
cfssl gencert \
   -ca=front-proxy-ca.pem \
   -ca-key=front-proxy-ca-key.pem  \
   -config=${config_path}/ca-config.json   \
   -profile=kubernetes \
   ${config_path}/front-proxy-client-csr.json | cfssljson -bare front-proxy-client

