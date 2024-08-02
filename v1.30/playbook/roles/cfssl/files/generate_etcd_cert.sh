#!/usr/bin/env bash
config_path="../files"
generate_files_path="../generate_files"

if [ ! -d $generate_files_path ]; then
    mkdir -p $generate_files_path
fi

cd $generate_files_path

cfssl gencert -initca ${config_path}/etcd-ca-csr.json | cfssljson -bare etcd-ca -
cfssl gencert -ca=etcd-ca.pem \
    -ca-key=etcd-ca-key.pem \
    -config=${config_path}/etcd-ca-config.json \
    -profile=etcd \
    etcd-csr.json | cfssljson -bare etcd