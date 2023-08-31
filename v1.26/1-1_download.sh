#!/bin/bash
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
    if [ ! -f "$package_dir/$file_name" ];then
        wget $url -O  $package_dir/$file_name
    else
        echo $file_name 已存在
    fi
}

echo -e "################################## \033[41m 下载二进制包 \033[0m ###################################"
echo "线上下载比较慢，建议手动下载上传到${package_dir}目录"

download_file https://github.com/opencontainers/runc/releases/download/v1.1.7/runc.amd64 runc.amd64
download_file https://github.com/containernetworking/plugins/releases/download/v1.1.1/cni-plugins-linux-amd64-v1.1.1.tgz cni-plugins-linux-amd64-v1.1.1.tgz
download_file https://github.com/containerd/containerd/releases/download/v1.7.2/cri-containerd-cni-1.7.2-linux-amd64.tar.gz cri-containerd-cni-1.7.2-linux-amd64.tar.gz
download_file https://dl.k8s.io/v1.26.6/kubernetes-server-linux-amd64.tar.gz kubernetes-server-linux-amd64.tar.gz
download_file https://github.com/etcd-io/etcd/releases/download/v3.5.9/etcd-v3.5.9-linux-amd64.tar.gz etcd-v3.5.9-linux-amd64.tar.gz
download_file https://github.com/cloudflare/cfssl/releases/download/v1.6.4/cfssl_1.6.4_linux_amd64 cfssl
download_file https://github.com/cloudflare/cfssl/releases/download/v1.6.4/cfssljson_1.6.4_linux_amd64 cfssljson
download_file https://github.com/cloudflare/cfssl/releases/download/v1.6.4/cfssl-certinfo_1.6.4_linux_amd64 cfssl-certinfo
# download_file http://rpmfind.net/linux/centos/7.9.2009/os/x86_64/Packages/chrony-3.4-1.el7.x86_64.rpm chrony-3.4-1.el7.x86_64.rpm
download_file https://get.helm.sh/helm-v3.12.1-linux-amd64.tar.gz helm-v3.12.1-linux-amd64.tar.gz

