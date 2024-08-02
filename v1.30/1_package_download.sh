#!/bin/bash

mode=${1:-download}

package_dir="playbook/roles/binary_package"


if command -v wget > /dev/null 2>&1;then
    echo "wget is already installed."
else
    code=$(curl -I -s --connect-timeout 2 www.baidu.com -w %{http_code} | tail -n1)
    if [ $code == "200" ];then
        yum install -y wget
    else
        echo "Online installation of ansible fails,please ensure the network is smooth."
    fi
fi

download_file() {
    url=$1
    file_name=$2
    file_path=$package_dir/$file_name
    
    if [ ! -f "$file_path" ];then
        if [ $mode == "check" ];then
            echo -e "\033[31m ${file_path} 文件不存在，请手动下载：${url} \033[0m"
        else
            wget $url -O  ${file_path}
        fi
    else
        echo -e "\e[32m ${file_path} 文件已存在 \e[0m"
    fi
}

echo -e "################################## \033[41m 下载二进制包 \033[0m ###################################"
echo "线上下载比较慢，建议手动下载上传到${package_dir}目录"

k8s_version="v1.30.3"
download_file https://dl.k8s.io/${k8s_version}/kubernetes-server-linux-amd64.tar.gz kubernetes-server-linux-amd64.tar.gz

etcd_version="v3.5.15"
download_file https://github.com/etcd-io/etcd/releases/download/${etcd_version}/etcd-${etcd_version}-linux-amd64.tar.gz etcd-${etcd_version}-linux-amd64.tar.gz

containerd_version="1.7.20"
download_file https://github.com/containerd/containerd/releases/download/v${containerd_version}/cri-containerd-cni-${containerd_version}-linux-amd64.tar.gz cri-containerd-cni-${containerd_version}-linux-amd64.tar.gz

runc_version="v1.1.13"
download_file https://github.com/opencontainers/runc/releases/download/${runc_version}/runc.amd64 runc.amd64

cni_version="v1.5.1"
download_file https://github.com/containernetworking/plugins/releases/download/${cni_version}/cni-plugins-linux-amd64-${cni_version}.tgz cni-plugins-linux-amd64-${cni_version}.tgz

cfssl_version="1.6.5"
download_file https://github.com/cloudflare/cfssl/releases/download/v${cfssl_version}/cfssl_${cfssl_version}_linux_amd64 cfssl
download_file https://github.com/cloudflare/cfssl/releases/download/v${cfssl_version}/cfssljson_${cfssl_version}_linux_amd64 cfssljson
download_file https://github.com/cloudflare/cfssl/releases/download/v${cfssl_version}/cfssl-certinfo_${cfssl_version}_linux_amd64 cfssl-certinfo

helm_version="v3.15.3"
download_file https://get.helm.sh/helm-${helm_version}-linux-amd64.tar.gz helm-${helm_version}-linux-amd64.tar.gz

