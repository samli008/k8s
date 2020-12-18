## set apiserver ip for skydns-rc.yaml
```
--kube-master-url=http://192.168.8.60:8080
```
## set cluster ip for skydns-svc.yaml
```
clusterIP: 10.0.0.254
```
## set kubelet on each nodes /usr/local/kubernetes/conf/kubelet 
```
KUBELET_ARGS="--cluster_dns=10.0.0.254 --cluster_domain=cluster.local"
systemctl restart kubelet
```
## create test pod busybox2 use nslookup service name
```
kubectl apply -f test_dns_pod.yaml
kubectl exec busybox2 -it sh
nslookup mysql
```
## if k8s version => 1.16 
```
sed -i 's|extensions/v1beta1|apps/v1|g' skydns-rc.yaml
```
