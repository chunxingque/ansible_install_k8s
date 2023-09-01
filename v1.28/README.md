# ansible_install_k8s

ansible部署二进制k8s集群,适用于1.28.x版本

功能：

1. 部署高可用ectd集群
2. 部署高可用master节点
3. 安装或者添加node节点
4. 更新自签证书


部署变化：

* 相较与v1.27版本, 组件的运行参数无变化


# 使用说明

## 要求

1. 系统要求：centos系统
2. 管理主机需要联网，安装ansible、wget等rpm包，下载k8s二进制包
3. 所有节点都需要访问到基本的rpm软件仓库或者内网的代理rpm仓库

注意：

* 仅在centos7.9内核为5.4上测试，建议系统内核通过elrepo升级到5.4


所有节点所需的rpm包，可以提前手动安装以下rpm包

k8s相关依赖

```
yum install curl conntrack ipvsadm ipset iptables sysstat libseccomp rsync jq psmisc lrzsz  bash-completion -y
```

时间同步

```
yum install chrony
```

keepalive与haproxy

```
yum install keepalive
yum install haproxy
```

nfs

```
yum install nfs-utils rpcbind
```



## 集群配置

需要配置master和node等信息,请根据模板配置

配置文件：playbook/group_vars/all.yaml


## 二进制包与镜像文件

因为基于内网安装，一些内网主机无法访问网络，所以需要管理主机能联网，并下载二进制包和导入必要的镜像

注意： 使用脚本下载可能比较慢，建议手动下载上传到playbook/roles/binary_package目录，下载地址参考downloads.sh

### 手动下载地址

具体版本请参考downloads.sh

1. 下载kubernetes各版本的二进制软件包： https://github.com/kubernetes/kubernetes/tree/master/CHANGELOG
2. etcdctl二进制包： https://github.com/etcd-io/etcd/releases
3. containerd二进制包： https://github.com/containerd/containerd/releases
4. runc二进制包： https://github.com/opencontainers/runc/releases
5. crictl二进制包： https://github.com/kubernetes-sigs/cri-tools/releases
6. cni插件二进制包：https://github.com/containernetworking/plugins/releases
7. cfssl二进制包：https://github.com/cloudflare/cfssl/releases
8. docker二进制包：https://download.docker.com/linux/static/stable/x86_64/
9. cri-docker二进制包：https://github.com/Mirantis/cri-dockerd/releases

### 脚本下载二进制包

使用脚本下载相关二进制包

```
sh 1-1_download.sh
```

### 导入镜像文件

需要导入pause镜像和calico的镜像，请安装完docker或者containerd后手动导入镜像文件，或者从其他机器拉取导入镜像文件，导入命令请参考tools

### 检查二进制包和镜像文件

检查二进制包是否下载完

```
sh 1-2_package_check.sh
```

## 管理主机配置

命令：

```
sh 2_manage_config.sh
```

在本机上执行以下任务：

1. 安装ansible
2. 生成 ansible hosts
3. 生成主机hosts_k8s
4. 生成ssh秘钥
5. 管理机对所有节点进行ssh免密认证

## 节点初始化配置

任务：

1. 在所有服务器上，初始化服务器环境，添加hosts,关闭防火墙、swap和selinux,配置nptdate时间同步
2. 在所有服务器上，设置hostname
3. 在所有服务器上，安装containerd
4. 在master服务器上，安装管理k8s的命令工具，helm，kubectl，kubeadm，cfssl
5. 重启所有服务器

执行脚本

```
sh 3_system_config.sh
```

注意：containerd的版本尽量与脚本要求一致，可能其他版本config.toml配置文件有所改变。

检查containerd

```
systemctl status containerd -l
```

## 安装k8s集群

### master组件安装

部署k8s集群(二进制部署)

1. cfssl生成etcd证书和k8s证书，证书过期日期为100年
2. 部署ETCD集群
3. 部署master插件：kube-apiserver、kube-controller-manager、kube-scheduler
4. 部署高可用的haproxy、keepalived

执行脚本

```
sh 4-1_k8s_master_install.sh
```

注意： 安装完etcd后，终端因为没有重新启动，需要重新打开一个会话终端，或者 `source /etc/profile.d/etcdctl.sh`，把etcd环境变量加载到当前会话，才能执行 `etcdctl member list --write-out=table` 检查etcd集群

检查etcd

```
systemctl status etcd -l
source /etc/profile.d/etcdctl.sh 
etcdctl member list --write-out=table
etcdctl endpoint health --write-out=table
```

检查keepalive和haproxy

```
systemctl status keepalived -l
systemctl status haproxy -l
```

检查master组件是否安装好

```
systemctl status kube-apiserver
systemctl status kube-controller-manager -l
systemctl status kube-scheduler -l
kubectl get cs
```

检查master组件是否有报错

```
tail -200f /var/log/messages
```



### node组件安装

node组件安装

1. 生成kubelet、kube-proxy的kubeconfig
2. 授权kube-apiserver访问kubelet
3. 部署node插件：kubelet、kube-proxy

安装命令

```
sh 4-2_k8s_node_install.sh
```

node节点检查是否有报错日志

```
systemctl status kubelet -l
systemctl status kube-proxy -l
tail -200f /var/log/messages
```

master上检查是否加入集群

```
kubectl get nodes
```



## k8s插件安装

注意：k8s插件安装，请先读脚本，再根据实际情况执行，因为有些要下载文件，可能因为网络问题无法下载，需要手动下载；有些镜像无法拉取，需要修改成可以的拉取镜像。

### cni网络插件

cilium和calico都是pod跨主机网络通信的插件，选一个即可

* calico： 比较稳定
* cilium： 基于ebpf，内核要求Linux kernel >= 4.9.17，性能比较好，功能强大



#### cilium

安装cilium,需要修改脚本的镜像地址

```
cd plugins/cilium
sh cilium_install.sh
```

需要等cilium安装完后，再安装hubble,因为cilium没有安装完，hubble会装到containerd的默认网段，导致访问不上，containerd的默认网段为10.88.0.1/16,而cilium的默认网段为 `10.0.0.0/8`

```
sh hubble_install.sh
```

检查

```
kubectl get pods -o wide -n kube-system
```



#### calico

容器跨主机网络通信

安装calico，需要修改镜像地址和pod的网段

```
cd plugins/calico
sh calico_install.sh
```



### coredns

k8s dns服务，安装前请修改脚本，需要修改coredns镜像地址和外部的dns地址，可以下载最新的coredns的yaml安装资源。

执行脚本

```
cd plugins/coredns
sh coredns_install.sh
```

检查coredns

```
kubectl get pods -o wide -n kube-system
```



### metrics-server

k8s监控指标,安装前请查看脚本，需要修改镜像

```
cd plugins/metrics-server
sh metrics-server_install.sh
```

检查

```
kubectl get pods -o wide -n kube-system
kubectl logs -f --tail 200 metrics-server-xx  -n kube-system
kubectl top nodes
```



### nginx

用于测试集群是否正常

```
cd plugins/nginx
kubectl apply -f nginx.yaml
```

检查

```
kubectl get pods 
kubectl get svc
```

访问地址：

curl  http://ip:30080

### ingress-nginx

#### helm方式安装

使用helm安装ingress-nginx

nodeport方式，80端口访问

```
cd plugins/ingress-nginx
kubectl apply -f helm_install_ingress.sh
```

#### 测试

```
kubectl apply -f ../nginx/nginx.yaml
kubectl apply -f ../nginx/nginx_ingress.yaml
```

### nfs-subdir-external-provisioner

使用nfs-subdir-external-provisioner作为k8s的可持续存储，存储数据

前提：

* 配置好nfs服务器
* 每个节点安装好nfs客户端

切换到nfs-subdir-external-provisioner目录

```
cd plugins/nfs-subdir-external-provisioner
```

挂载nfs的logs目录,修改nfs-logs.sh的nfs的ip和路径，再执行脚本

```
sh nfs-logs.sh
```

测试

```
kubectl apply -f nfs-k8s-logs-storageclass-dev.yaml
kubectl apply -f pvc-logs-dev.yaml
```

### kube-prometheus

k8s集群监控

替换镜像，镜像为本地代理镜像，如需替换镜像，请自行修改

```
cd plugins/kube-prometheus
sh modify_image.sh
```

kube-prometheus安装

```
sh kube-prometheus_install.sh
```

使用nodePort访问prometheus

```
sh modify_services.sh
```

## 增加node节点

主机配置上添加新节点

```
vim playbook/group_vars/all.yaml
```

add_server_group列表中添加主机

```
add_server_group:
   - name: k8s-node1
     ip: 192.168.15.244

```

node_server列表中添加主机

```
node_server:
  - name: k8s-node1
    ip: 192.168.15.244
```

可以在新节点添加成功后再添加；如何添加节点失败，记得删除。

作用：

1. 记录现有node节点
2. 当添加一个新的node节点时，也需要更新该节点hosts文件

### node节点系统初始化

```
sh 5-1_new_node_config.sh
```

任务：

1. 生成ansible hosts文件
2. 修改主机hosts文件
3. 新节点初始化配置
4. containerd安装
5. 重启主机

检查服务

```
systemctl status containerd
systemctl status chronyd.service
```

### node组件安装

命令：

```
sh 5-2_new_node_install.sh
```

任务

* kubelet安装
* kube-proxy安装

### 检查node组件是否安装正常

new_node 检查是否有报错日志

```
systemctl status kubelet -l
systemctl status kube-proxy -l
tail -200f /var/log/messages



```

master上检查是否加入集群，cni组件是否安装正常，cni组件：cilium或者calico

```
kubectl get nodes
kubectl get pods  -o wide -n kube-system
```

## 更新自签名证书

功能:

* 更新etcd的证书
* 更新k8s集群的证书

多次测试，更新ssl签名没啥问题了。但是有一定的风险，别轻易操作

命令：

```
sh update_certificate.sh
```

ETCD集群健康检查

```
etcdctl member list --write-out=table
etcdctl endpoint health --write-out=table
kubectl get cs
```

检查k8s集群

```
# 检查日志是否有报错
tail -200f /var/log/messages
# 检查节点是否正常
kubectl get nodes
# 检查组件是否正常
kubectl get cs
# 检查组件日志是否报错
systemctl status kube-apiserver.service -l
systemctl status kube-controller-manager.service -l
systemctl status kube-scheduler.service -l
systemctl status kube-proxy.service -l
systemctl status kubelet.service -l
```

# k8s集群管理

## containerd

### 更新containerd配置

修改ansible-playbook playbook/containerd_manage.yaml的hosts，更新config.toml配置

```
ansible-playbook -i k8s_hosts playbook/containerd_manage.yaml --tags=update_config
```
