#!/bin/bash
package_dir="playbook/roles/binary_package"

file_is_exist() {
    file_name=$1
    file_path=$package_dir/$file_name

    if [ ! -f "$file_path" ];then
        echo -e "\033[31m ${file_path} 文件不存在，请手动下载 \033[0m"
    else
        echo -e "\e[32m ${file_path} 文件已存在 \e[0m"
    fi
}

image_is_exist() {
    file_name=$1
    file_path=$package_dir/$file_name

    if [ ! -f "$file_path" ];then
        echo -e "\033[31m ${file_path} 镜像文件不存在，安装containerd后会自动导入或从其他机器手动拉取导入\033[0m"
    else
        echo -e "\e[32m ${file_path} 镜像文件已存在 \e[0m"
    fi
}

file_is_exist runc.amd64
file_is_exist cni-plugins-linux-amd64-v1.1.1.tgz
file_is_exist cri-containerd-cni-1.7.2-linux-amd64.tar.gz
file_is_exist kubernetes-server-linux-amd64.tar.gz
file_is_exist etcd-v3.5.9-linux-amd64.tar.gz
file_is_exist cfssl
file_is_exist cfssljson
file_is_exist cfssl-certinfo
# file_is_exist chrony-3.4-1.el7.x86_64.rpm
file_is_exist helm-v3.12.1-linux-amd64.tar.gz

image_is_exist pause.tar

