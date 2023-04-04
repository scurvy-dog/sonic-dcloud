### sonic config_db.json

Edit /etc/sonic/config_db.json

1. Add lines to device meta data:

```
    "DEVICE_METADATA": {
        "localhost": { 
            "hostname": "router-3",
            "deployment_id": "1", 
            "bgp_asn": "65003",
            "type": "ToR",
            "docker_routing_config_mode": "split"
        }
    }, 
```

2. Add loopback and Ethernet interface IPs:
```
    "LOOPBACK_INTERFACE": {
        "Loopback0|10.0.0.3/32": {},
        "Loopback0|FC00:0000:3::1/128": {}
    },
    "INTERFACE": {
        "Ethernet0": {},
        "Ethernet0|10.1.1.3/31": {},
        "Ethernet0|fc00:0::3/127": {},
        "Ethernet4": {},
        "Ethernet4|10.1.1.5/31": {},
        "Ethernet4|fc00:0::5/127": {}
    },
```

3. BGP config
```
    "BGP_NEIGHBOR": {
        "10.1.1.2": {
            "name": "r1",
            "local_addr": "10.1.1.3",
            "asn": 65001,
            "rrclient": "0", 
            "nhopself": "1"
        },
        "10.1.1.4": {
            "name": "r2", 
            "local_addr": "10.1.1.5", 
            "asn": 65002,
            "rrclient": "0", 
            "nhopself": "1"
        },
        "fc00:0::2": {
            "name": "r1v6",
            "local_addr": "fc00:0::3",
            "asn": 65001,
            "rrclient": "0", 
            "nhopself": "1"
        },
        "fc00:0::4": {
            "name": "r2v6", 
            "local_addr": "fc00:0::5", 
            "asn": 65002,
            "rrclient": "0", 
            "nhopself": "1"
        }
    }, 
```

4. save the file and reload config:
```
sudo config reload
```
Example:
```
cisco@sonic:/etc/sonic$ sudo config reload
Clear current config and reload config in config_db format from the default config file(s) ? [y/N]: y
Disabling container monitoring ...
Stopping SONiC target ...
Running command: /usr/local/bin/sonic-cfggen  -j /etc/sonic/init_cfg.json  -j /etc/sonic/config_db.json  --write-to-db
Running command: /usr/local/bin/db_migrator.py -o migrate
Running command: /usr/local/bin/sonic-cfggen -d -y /etc/sonic/sonic_version.yml -t /usr/share/sonic/templates/sonic-environment.j2,/etc/sonic/sonic-environment
Restarting SONiC target ...
Enabling container monitoring ...
Reloading Monit configuration ...
Reinitializing monit daemon
cisco@sonic:/etc/sonic$ 
```
- config reload takes a few minutes to load the vxr interfaces. check status with:
```
show interfaces status
```
