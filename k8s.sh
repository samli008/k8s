rm -rf /etc/yum.repos.d/*
mv *.repo /etc/yum.repos.d/
yum -y install docker kubelet kubeadm kubectl
sed -i '/ExecStart/a\--insecure-registry 192.168.6.121:4000 \\' /usr/lib/systemd/system/docker.service
systemctl enable docker
systemctl start docker
systemctl enable kubelet
systemctl start kubelet

cat > /etc/sysconfig/kubelet << EOF
KUBELET_EXTRA_ARGS="--fail-swap-on=false"
EOF

swapoff -a

cat >> /etc/sysctl.d/k8s.conf << EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

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

# create k8s cluster master
kubeadm init --kubernetes-version=v1.15.0 --pod-network-cidr=10.244.0.0/16

#export KUBECONFIG=/etc/kubernetes/admin.conf
#kubectl apply -f /root/kube-flannel.yml

#journalctl -f -u kubelet
#kubectl get pods --all-namespaces
#kubectl get cs
#kubectl get node

#kubeadm token list
#kubeadm join node1:6443 --token yv2ov9.f0h4fuzvi9thcphu --discovery-token-unsafe-skip-ca-verification

# deploy dashboard
kubectl apply -f kubernetes-dashboard.yaml 
kubectl apply -f admin-role.yaml
kubectl apply -f kubernetes-dashboard-admin.rbac.yaml 
kubectl -n kube-system get svc

# delete node on k8s master
kubectl drain k3 --delete-local-data --force --ignore-daemonsets
kubectl delete node k3
# on k3 node
kubeadm reset

# set node role
kubectl label node k3 node-role.kubernetes.io/worker=
kubectl get node -o wide
kubectl apply -f nginx.yml
kubectl apply -f nginx-service.yml
