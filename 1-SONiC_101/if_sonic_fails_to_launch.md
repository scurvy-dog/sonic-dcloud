### validate sonic nodes have successfully deployed

1. check ansible launch script logs at



### if a sonic node fails to launch at dcloud lab startup


cisco@vm-spine-1:~$ docker ps
CONTAINER ID   IMAGE                 COMMAND                  CREATED       STATUS       PORTS     NAMES
9a970059dd16   c8000-clab-sonic:29   "/etc/prepEnv.sh /no…"   3 hours ago   Up 3 hours             clab-c8201-sonic-spine-1
cisco@vm-spine-1:~$ docker exec -it clab-c8201-sonic-spine-1 bash
root@spine-1:/# cd nobackup/
root@spine-1:/nobackup# ./startup.sh 8000.yaml 4