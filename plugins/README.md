## 常用插件

常用插件的安装

## harbor

创建harbor秘钥

```
cd harbor
sh harbor-secret.sh
```

## ingress-nginx

### helm方式安装

使用helm安装ingress-nginx

#### deployment+nodeport

nodeport方式，80端口访问

```
cd ingress-nginx
kubectl apply -f helm_install_ingress.sh
```



#### DaemonSet+hostNetwork+nodeSelector

此方案的主要的目的： 

* 使用host网络可以使请求直接转发到ingress-nginx，减少转发的步骤；
* 通过ingress地址直接访问后端应用，后端应用可以获取到客户端的真实IP；


先打标签，确认ingress-nginx部署到节点

```
kubectl label nodes k8s-m1  ingress=nginx
```

values_v2.yaml参数说明：

controller.admissionWebhooks.port默认8443，可能会与k8s集群的haproxy代理冲突，可以改为7443

addHeaders参数主要添加记录客户端IP的配置参数，目的是为了让后端程序获取到客户端的真实IP



然后执行脚本

```
cd ingress-nginx
kubectl apply -f helm_install_ingress_v2.sh
```



### 测试

```
kubectl apply -f ../nginx/nginx.yaml
kubectl apply -f ../nginx/nginx_ingress.yaml
```



## nfs-subdir-external-provisioner

使用nfs-subdir-external-provisioner作为k8s的可持续存储，存储数据

前提：

* 配置好nfs服务器
* 每个节点安装好nfs客户端

切换到nfs-subdir-external-provisioner目录

```
cd nfs-subdir-external-provisioner
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

## kube-prometheus

k8s集群监控

下载资源

```
git clone https://github.com/prometheus-operator/kube-prometheus.git
```

替换镜像，镜像为本地代理镜像，如需替换镜像，请自行修改

```
cd kube-prometheus
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

#### 告警配置

修改告警规则，添加webhook地址

```
# 安装企业微信webhook
kubectl apply -f alertmanager/prometheus-webhook-qywx.yaml
# 修改webhook地址
kubectl apply -f alertmanager/alertmanager-secre.yaml
```
