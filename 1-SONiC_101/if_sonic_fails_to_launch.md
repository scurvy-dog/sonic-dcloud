# SONiC Node Failure Instructions

### If a SONiC node fails to launch at dcloud lab startup

1. ssh to the sonic node's host VM:

     | Host name  | IP Address     |
     |:-----------|:---------------|
     | vm-leaf-1  | 198.18.128.101 |
     | vm-leaf-2  | 198.18.128.102 |
     | vm-spine-1 | 198.18.128.103 |
     | vm-spine-2 | 198.18.128.104 |

2. Determine the local sonic-vxr8000 container's name:
   ```
   docker ps
   ```
   Example output:
   ```
   cisco@vm-spine-2:~$ docker ps
   CONTAINER ID   IMAGE                 COMMAND                  CREATED          STATUS          PORTS     NAMES
   d1861990e9a8   c8000-clab-sonic:31   "/etc/prepEnv.sh /no…"   21 minutes ago   Up 21 minutes             clab-c8101-sonic-spine-2
   cisco@vm-spine-2:~$
   ```

3. Access the docker container through an exec shell:
   ```
   docker exec -it <container name or ID> bash
   ```
   Example:
   ```
   docker exec -it clab-c8101-sonic-spine-2 bash
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

   Truncated example output:
   ```
   cisco@spine-2:~$ docker exec -it  clab-c8101-sonic-spine-2 bash
   root@spine-2:/# cd nobackup/
   root@spine-2:/nobackup# ./startup.sh 8000.yaml 4
   Invoking /nobackup/startup.py 8000.yaml 4 4
   ['/nobackup/startup.py', '8000.yaml', '4', '4']
   MGMT_IP: 172.10.10.104  MASK: 255.255.255.0  GATEWAY: 172.10.10.1
   Found 4 data interfaces (expected 4)
   ...
   ...
   22:40:57 INFO R0:onie sonic login cisco/cisco123
   22:40:57 INFO R0:reached sonic prompt
   22:40:57 INFO R0:checking interfaces
   22:41:01 INFO R0:found 0 interfaces (expected 32)
   22:41:32 INFO R0:found 0 interfaces (expected 32)
   22:42:04 INFO R0:found 32 interfaces (expected 32)
   22:42:04 INFO R0:applying XR config
   22:42:12 INFO Sim up
   Router up
   ```
