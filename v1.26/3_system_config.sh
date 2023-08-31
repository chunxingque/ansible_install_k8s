#!/usr/bin/env bash

set -e
echo -e "#################### \033[41m install chrony & time sync  \033[0m ############################################"
ansible-playbook playbook/system_config.yaml --tags chrony -i k8s_hosts
echo -e "############### \033[41m update hostname and /etc/hosts & Close firewalld and selinux and swap space \033[0m #"
echo -e "#################### \033[41m system config and modules-load \033[0m #########################################"
ansible-playbook playbook/system_config.yaml --tags system_config -i k8s_hosts
echo -e "#################### \033[41m install containerd \033[0m #####################################################"
ansible-playbook playbook/system_config.yaml --tags containerd_install -i k8s_hosts
echo -e "#################### \033[41m manage host export image and all host import image \033[0m #####################"
# 管理主机导出镜像
ansible-playbook -i k8s_hosts --tags export_image  playbook/import_images.yaml
# 所有节点导入镜像
ansible-playbook -i k8s_hosts --tags import_image  playbook/import_images.yaml
echo -e "#################### \033[41m reboot all hosts \033[0m #######################################################"
ansible-playbook playbook/reboot.yaml -i k8s_hosts
# 检查containerd_install
# systemctl status containerd