#!/usr/bin/env bash
# k8s ca
cfssl gencert -initca ca-csr.json | cfssljson -bare ca -
mv -f ca.pem ca-key.pem ca.csr ../generate_files/

# kube-apiserver
cfssl gencert \
-ca=../generate_files/ca.pem \
-ca-key=../generate_files/ca-key.pem \
-config=ca-config.json \
-profile=kubernetes \
../generate_files/kube-apiserver-csr.json | cfssljson -bare kube-apiserver
mv -f kube-apiserver.pem kube-apiserver-key.pem kube-apiserver.csr ../generate_files/

# kube-apiserver and kube-controller-manager ServiceAccountKey
openssl genrsa -out sa.key 2048
openssl rsa -in sa.key -pubout -out sa.pub
mv -f sa.key sa.pub  ../generate_files/

# kube-controller-manager
cfssl gencert \
   -ca=../generate_files/ca.pem \
   -ca-key=../generate_files/ca-key.pem \
   -config=ca-config.json \
   -profile=kubernetes \
   kube-controller-manager-csr.json | cfssljson -bare kube-controller-manager
mv -f kube-controller-manager.pem kube-controller-manager-key.pem kube-controller-manager.csr ../generate_files/

# kube-scheduler
cfssl gencert \
   -ca=../generate_files/ca.pem \
   -ca-key=../generate_files/ca-key.pem \
   -config=ca-config.json \
   -profile=kubernetes \
   kube-scheduler-csr.json | cfssljson -bare kube-scheduler
mv -f kube-scheduler.pem kube-scheduler-key.pem kube-scheduler.csr ../generate_files/


# kubectl
cfssl gencert \
   -ca=../generate_files/ca.pem \
   -ca-key=../generate_files/ca-key.pem \
   -config=ca-config.json \
   -profile=kubernetes \
   admin-csr.json | cfssljson -bare admin
mv -f admin.pem admin-key.pem admin.csr ../generate_files/


# front-proxy-client
cfssl gencert -initca front-proxy-ca-csr.json | cfssljson -bare front-proxy-ca
cfssl gencert \
-ca=front-proxy-ca.pem \
-ca-key=front-proxy-ca-key.pem  \
-config=ca-config.json   \
-profile=kubernetes front-proxy-client-csr.json | cfssljson -bare front-proxy-client
mv -f front-proxy-ca.pem front-proxy-ca-key.pem front-proxy-ca.csr front-proxy-client.pem front-proxy-client-key.pem front-proxy-client.csr ../generate_files/

