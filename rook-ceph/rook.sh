# 在master节点上下载Rook部署Ceph集群
git clone --single-branch --branch release-1.2 https://github.com/rook/rook.git
cd rook/cluster/examples/kubernetes/ceph
kubectl create -f common.yaml
sed -i 's|rook/ceph:v1.2.6|registry.cn-hangzhou.aliyuncs.com/vinc-auto/ceph:v1.2.6|g' operator.yaml
kubectl create -f operator.yaml
kubectl -n rook-ceph get pod -o wide

# 默认的集群配置文件简单梳理：
# cluster.yaml 是生产存储集群配置，需要至少三个节点
# cluster-test.yaml 是测试集群配置，只需要一个节点
# cluster-minimal.yaml 仅仅会配置一个ceph-mon和一个ceph-mgr
# 修改集群配置文件，替换镜像，关闭所有节点和所有设备选择，手动指定节点和设备
sed -i 's|ceph/ceph:v14.2.8|registry.cn-hangzhou.aliyuncs.com/vinc-auto/ceph:v14.2.8|g' cluster.yaml
sed -i 's|useAllNodes: true|useAllNodes: false|g' cluster.yaml
sed -i 's|useAllDevices: true|useAllDevices: false|g' cluster.yaml
