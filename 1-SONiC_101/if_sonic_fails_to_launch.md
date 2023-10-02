### if a sonic node fails to launch at dcloud lab startup

1. ssh to the sonic node's host VM:

     | Host name  | IP Address     |
     |:-----------|:---------------|
     | vm-leaf-1  | 198.18.128.101 |
     | vm-leaf-2  | 198.18.128.102 |
     | vm-spine-1 | 198.18.128.103 |
     | vm-spine-2 | 198.18.128.104 |

2. get the local sonic-vxr8000 container's name:

```
docker ps
```
Example output:
```
cisco@vm-leaf-2:~$ docker ps
CONTAINER ID   IMAGE                 COMMAND                  CREATED          STATUS          PORTS     NAMES
d1861990e9a8   c8000-clab-sonic:31   "/etc/prepEnv.sh /no…"   21 minutes ago   Up 21 minutes             clab-c8101-sonic-leaf-2
cisco@vm-leaf-2:~$ 
```

3. docker exec into the container:

```
docker exec -it <container name or ID> bash
```
Example:
```
docker exec -it clab-c8101-sonic-leaf-2 bash
```

4. change directory into 'nobackup'
```
cd nobackup
```

5. Run the startup.sh shell script as follows:

   If leaf-1 or leaf-2 failed:
   ```
   ./startup.sh 8000.yaml 5
   ```

   if spine-1 or spine-2 failed:
   ```
   ./startup.sh 8000.yaml 4
   ```

6. The script will output log info very similar to the docker logs info. After about 8-10 minutes we expect to see a 'Router up' message. 

