#!/bin/bash
# metrics-server安装脚本

# 下载最新的 https://github.com/kubernetes-sigs/metrics-server/releases
# wget https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.6.4/components.yaml

alias cp='cp'
cp -f components.yaml components_modify.yaml

# 添加运行参数,注意，每个节点都需要有front-proxy-ca.pem文件
cat > temp.txt << EOF
        - --kubelet-insecure-tls
        - --requestheader-client-ca-file=/etc/kubernetes/pki/front-proxy-ca.pem
        - --requestheader-username-headers=X-Remote-User
        - --requestheader-group-headers=X-Remote-Group
        - --requestheader-extra-headers-prefix=X-Remote-Extra-
EOF
sed -i '/metric-resolution/r temp.txt' components_modify.yaml

# 添加挂载目录
cat > temp.txt << EOF
        - name: ca-ssl
          mountPath: /etc/kubernetes/pki
EOF
sed -i '/volumeMounts/r temp.txt' components_modify.yaml

# 添加挂载卷
cat > temp.txt << EOF
      - name: ca-ssl
        hostPath:
          path: /etc/kubernetes/pki
EOF
sed -i '/volumes:/r temp.txt' components_modify.yaml

#修改镜像 192.168.15.124/aliyuncs/google_containers/metrics-server替换registry.k8s.io/metrics-server/metrics-server镜像
sed -i 's#registry.k8s.io\/metrics-server\/metrics-server#192.168.15.124\/aliyuncs\/google_containers\/metrics-server#g'  components_modify.yaml
kubectl apply -f components_modify.yaml

# 检查
# kubectl top nodes 