## k8s管理工具



### kubelet证书更新

kubelet的客户和服务证书的有效期为一年，kubelet的客户证书一般设置了自动续期，而服务证书则还需要手动更新，服务证书过期其实影响不到k8s集群的正常功能，不过kube-prometheus会进行告警，需要进行更新。

本脚本会可以批量更新k8s节点的kubelet的客户和服务证书

```
ansible-playbook -i ../v1.30/k8s_hosts  update_kubelet_cert.yaml
```
