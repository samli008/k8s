## init docker swarm
```
docker swarm init --advertise-addr 192.168.6.131
docker swarm join-token worker
docker swarm join-token manager
```
## join cluster as manager node
```
docker swarm join --token SWMTKN-1-2zt0zjw31onyg4w0p7qnmifjugw7ukdamkd7c39zwr9f9n0ell-9wk6hvjhendy0w9hz2go6qncq 192.168.6.131:2377
```
## join cluster as worker node
```
docker swarm join --token SWMTKN-1-2zt0zjw31onyg4w0p7qnmifjugw7ukdamkd7c39zwr9f9n0ell-7ohl75hvh0irxeko7b0kklk0k 192.168.6.131:2377
```
## show docker node
```
docker node ls
```
