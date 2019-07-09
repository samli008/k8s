#!/bin/bash
images=(kube-apiserver:v1.15.0 kube-controller-manager:v1.15.0 kube-scheduler:v1.15.0 kube-proxy:v1.15.0 pause:3.1 etcd:3.3.10 kubernetes-dashboard-amd64:v1.10.1 flannel:v0.11.0-amd64 )

for imageName in ${images[@]} ; do
   
  docker pull 192.168.6.121:4000/$imageName  
  docker tag 192.168.6.121:4000/$imageName k8s.gcr.io/$imageName  
  docker rmi 192.168.6.121:4000/$imageName
done

docker pull 192.168.6.121:4000/coredns:1.3.1
docker tag 192.168.6.121:4000/coredns:1.3.1  k8s.gcr.io/coredns:1.3.1
docker rmi 192.168.6.121:4000/coredns:1.3.1

docker pull 192.168.6.121:4000/flannel:v0.10.0-amd64
docker tag 192.168.6.121:4000/flannel:v0.10.0-amd64  k8s.gcr.io/flannel:v0.10.0-amd64
docker rmi 192.168.6.121:4000/flannel:v0.10.0-amd64
