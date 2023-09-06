# ansible安装k8s脚本

本脚本通过ansible来快速安装和管理二进制k8s集群；支持高可用k8s集群和单机k8s集群地部署；支持不同版本k8s集群部署，一般小版本的部署脚本基本是通用的。 `plugins` 目录为k8s的常用插件。

支持kubenetes版本：v1.18.x，v1.26.x，v1.27.x，v1.28.x


## 脚本变化

### v1.26

* 无


### v1.27

* 相较于上个版本，删除了kube-controller-manager的--pod-eviction-timeout的运行参数
* pause镜像获取方式变更为直接拉取，之前的方式为从管理中导出pause镜像，再传到所有节点进行导入pause镜像。因此需要所有节点能够拉取到pause镜像，建议修改pause的地址为docker私有仓库的地址。


### v1.28

* 相较与v1.27版本, 组件的运行参数无变化
