## deploy k8s
```
1. common.yaml
2. docker.yaml
3. etcd.yaml
4. keepalived.yaml
5. apiserver.yaml
6. controller_manager_scheduler.yaml
7. node.yaml
8. sh label
9. etcdctl mk /atomic.io/network/config '{ "Network": "10.10.0.0/16","SubnetLen": 24,"Backend": {"Type": "host-gw"} }'
10. flannel.yaml; etcdctl ls /atomic.io/network/subnets
11. sh flannel_docker
12. load.yaml
13. kubectl apply -f nginx.yaml
14. kubectl apply -f nginx-service.yaml
15. kubectl apply -f dashboard.yaml

iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT

etcdctl member list
kubectl get cs
kubectl get node

export ETCDCTL_API=3
etcdctl get / --prefix --keys-only
etcdctl get /registry/deployments/default --prefix --keys-only
```
![](./img/k8s.jpg)
