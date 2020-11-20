#!/bin/bash
images=(kube-apiserver:v1.15.0 kube-controller-manager:v1.15.0 kube-scheduler:v1.15.0 kube-proxy:v1.15.0 pause:3.1 etcd:3.3.10 kubernetes-dashboard-amd64:v1.10.1 flannel:v0.11.0-amd64 )

for imageName in ${images[@]} ; do
   
  docker pull mirrorgooglecontainers/$imageName  
  docker tag mirrorgooglecontainers/$imageName k8s.gcr.io/$imageName  
  docker rmi mirrorgooglecontainers/$imageName
done

docker pull coredns/coredns:1.3.1
docker tag coredns/coredns:1.3.1  k8s.gcr.io/coredns:1.3.1
docker rmi coredns/coredns:1.3.1

docker pull keveon/flannel:v0.10.0-amd64
docker tag keveon/flannel:v0.10.0-amd64  k8s.gcr.io/flannel:v0.10.0-amd64
docker rmi keveon/flannel:v0.10.0-amd64
