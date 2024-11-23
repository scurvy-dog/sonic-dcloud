### Notes on sonic-vs-8101-32H

1. load docker image:
```
docker load -i sonic-vs-8101-32H.tar.gz
```

2. containerlab deploy:
```
clab deploy -t sonic-vs-topo.yaml
```

3. ssh to any of the sonic-vs nodes (user: admin, password: admin):
```
ssh admin@clab-sonic-vs-LF09
```

4. Check sonic docker containers:
```
docker ps -a
```

Note: SWSS container may crash or go into an Exited state a couple times. 
Expect the nodes to all stabilize after about 10 minutes.

