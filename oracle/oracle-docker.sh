# deploy oracle11g on docker
docker run -d --name=oracle -p 8181:8080 -p 1521:1521 -v /oracle/data:/u01/app/oracle oracle11g:latest

# deploy oracle11g on k8s
kubectl apply -f oracle11g.yaml --namespace=kube-public
kubectl get svc --namespace=kube-public

# k8s internal link
hostname: oracle-svc.kube-public
port: 1521
sid: EE
service name: EE.oracle.docker
username: system
password: oracle

# k8s external link
hostname: 192.168.8.24
port: 32175
sid: EE
service name: EE.oracle.docker
username: system
password: oracle

# oracle client with sqlplus
sqlplus system/oracle@//192.168.8.24:1521/EE.oracle.docker
sqlplus system/oracle@//192.168.8.24:31521/EE.oracle.docker
