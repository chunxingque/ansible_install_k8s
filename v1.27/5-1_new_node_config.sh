#!/usr/bin/env bash
# author:icepopfh
# date:2021-01-18

set -e

echo -e "################################### \033[41m generate ansible hosts \033[0m ##################################"
ansible-playbook playbook/manager_config.yaml --tags ansible_hosts
echo -e "#################### \033[41m ssh auth \033[0m ###############################################################"
ansible-playbook playbook/add_node.yaml --tags ssh_auth
echo -e "#################### \033[41m install chrony & time sync  \033[0m ############################################"
ansible-playbook playbook/add_node.yaml --tags chrony -i k8s_hosts
echo -e "############### \033[41m update hostname and /etc/hosts & Close firewalld and selinux and swap space \033[0m #"
echo -e "#################### \033[41m system config and modules-load \033[0m #########################################"
ansible-playbook playbook/add_node.yaml --tags system_config -i k8s_hosts
echo -e "#################### \033[41m install containerd \033[0m #####################################################"
ansible-playbook playbook/add_node.yaml --tags containerd_install -i k8s_hosts
echo -e "#################### \033[41m  host import image \033[0m #####################################################"
ansible-playbook playbook/add_node.yaml --tags import_image -i k8s_hosts
echo -e "#################### \033[41m reboot all hosts \033[0m #######################################################"
ansible-playbook playbook/reboot_new_node.yaml -i k8s_hosts

