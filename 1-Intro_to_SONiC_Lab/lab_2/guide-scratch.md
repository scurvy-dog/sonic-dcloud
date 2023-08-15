# Scratch Guide Lab 2

startup container status
cisco@sonic:~$ docker ps
CONTAINER ID   IMAGE                                COMMAND                  CREATED        STATUS        PORTS     NAMES
868157a8bbf5   docker-snmp:latest                   "/usr/local/bin/supe…"   11 hours ago   Up 11 hours             snmp
5644f3c91087   docker-sonic-mgmt-framework:latest   "/usr/local/bin/supe…"   11 hours ago   Up 11 hours             mgmt-framework
c348a33dccdc   b3af60f661d0                         "/usr/bin/docker_ini…"   11 hours ago   Up 11 hours             dhcp_relay
099b9115a440   docker-router-advertiser:latest      "/usr/bin/docker-ini…"   11 hours ago   Up 11 hours             radv
878549b44ead   docker-lldp:latest                   "/usr/bin/docker-lld…"   11 hours ago   Up 11 hours             lldp
aa1c44498dee   docker-fpm-frr:latest                "/usr/bin/docker_ini…"   11 hours ago   Up 11 hours             bgp
0a8f12abe9c6   docker-teamd:latest                  "/usr/local/bin/supe…"   11 hours ago   Up 11 hours             teamd
f2996f06bc05   docker-syncd-cisco:latest            "/usr/local/bin/supe…"   11 hours ago   Up 11 hours             syncd
20db7f99de4e   docker-orchagent:latest              "/usr/bin/docker-ini…"   11 hours ago   Up 11 hours             swss
5b7c42be2fbc   docker-platform-monitor:latest       "/usr/bin/docker_ini…"   11 hours ago   Up 11 hours             pmon
199dfb786c07   docker-database:latest               "/usr/local/bin/dock…"   11 hours ago   Up 11 hours             database


