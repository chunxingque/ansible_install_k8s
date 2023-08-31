#!/usr/bin/env bash

cfssl gencert -initca etcd-ca-csr.json | cfssljson -bare etcd-ca -
cfssl gencert -ca=etcd-ca.pem \
-ca-key=etcd-ca-key.pem \
-config=etcd-ca-config.json \
-profile=etcd \
../generate_files/etcd-csr.json | cfssljson -bare etcd

mv -f etcd-ca.pem etcd-ca-key.pem etcd-ca.csr etcd.pem etcd-key.pem etcd.csr ../generate_files/