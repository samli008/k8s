# on all nodes install docker and local docker registry2
yum -y install docker kubelet kubeadm kubectl
sed -i '/ExecStart/a\--insecure-registry 192.168.6.121:4000 \\' /usr/lib/systemd/system/docker.service
systemctl enable docker
systemctl start docker
systemctl enable kubelet
systemctl start kubelet

docker load < registry2.tar
docker run -d -v /root/registry:/var/lib/registry --name k8s_registry --restart always -p 4000:5000 registry:2
curl http://localhost:4000/v2/_catalog

cat > /etc/sysconfig/kubelet << EOF
KUBELET_EXTRA_ARGS="--fail-swap-on=false"
EOF

swapoff -a

cat >> /etc/sysctl.d/k8s.conf << EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system


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

# deploy application
kubectl apply -f nginx.yml
kubectl apply -f nginx-service.yml
