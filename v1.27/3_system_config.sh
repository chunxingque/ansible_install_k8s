#!/usr/bin/env bash

set -e
echo -e "#################### \033[41m install chrony & time sync  \033[0m ############################################"
ansible-playbook playbook/system_config.yaml --tags chrony -i k8s_hosts
echo -e "############### \033[41m update hostname and /etc/hosts & Close firewalld and selinux and swap space \033[0m #"
echo -e "#################### \033[41m system config and modules-load \033[0m #########################################"
ansible-playbook playbook/system_config.yaml --tags system_config -i k8s_hosts
echo -e "#################### \033[41m install containerd \033[0m #####################################################"
ansible-playbook playbook/system_config.yaml --tags containerd_install -i k8s_hosts
echo -e "#################### \033[41m reboot all hosts \033[0m #######################################################"
ansible-playbook playbook/reboot.yaml -i k8s_hosts
