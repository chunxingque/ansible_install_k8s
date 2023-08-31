# ansible_install_k8s

ansible部署k8s集群,适用于1.8版本

参考地址：https://github.com/icepopfh/ansible-install-k8s

# 使用说明

## 1、管理主机配置

### 1.manage_config.sh

在本机上执行以下任务：

1. 安装ansible
2. 生成 ansible hosts
3. 生成hosts_k8s
4. 生成ssh秘钥

## 2、所有主机初始化配置

### 2.all_system_config.sh

任务：

1. 在所有服务器上，初始化服务器环境，添加hosts,关闭防火墙、swap和selinux,配置nptdate时间同步
2. 在所有服务器上，设置hostname
3. 在所有服务器上，安装docker
4. 在master服务器上，安装管理k8s的命令工具，helm，kubectl，kubeadm，cfssl
5. 重启所有服务器

## 3、安装k8s集群

### 3-1.k8s_install.sh

部署k8s集群(二进制部署)

1. cfssl根据不同的插件生成不同的ca证书和认证证书
2. 部署ETCD集群
3. 部署网络插件flannel（可以部署在k8s集群里，然后通过Daemonset这个资源对象去保证每个节点只有一个flannel，这样新增的节点会自动去部署flannel）
4. 部署master插件：kube-apiserver、kube-controller-manager、kube-scheduler
5. 部署node插件：kubelet、kube-proxy
6. 部署高可用的haproxy、keepalived

### 3-2.k8s_install.sh

配置flannel网络并重启docker


## 4、增加node节点

### 4.1.add_cluster_node.sh

安装部署新的k8s-node

任务：

1. 生成ansible hosts文件
2. 修改主机hosts文件
3. 新节点初始化配置
4. docker安装
5. kubelet安装
6. kubeproxy安装


### 4-2.add_cluster_node.sh

配置新node的flannel网络（在新节点的flannel进入running状态后再执行）


## 5、更新自签名证书

### 5.replace_certificate.sh

更新自签名证书
