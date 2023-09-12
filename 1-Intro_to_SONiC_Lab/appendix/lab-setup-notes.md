## lab setup from scratch

### on each VM:

1. Install docker and OVS
```
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo   "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" |   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin openvswitch-switch bridge-utils -y

sudo usermod -aG docker $USER
```
2. clone repository
```
git clone https://github.com/scurvy-dog/sonic-dcloud.git
```

3. copy sonic image files to each VM
```
mkdir images
cd images

sftp 198.18.128.100
cd images

get sonic-cisco-8000-clab.bin
get c8000-clab-sonic_29.tar.gz
```

4. docker load sonic image on each VM
```
docker load -i c8000-clab-sonic_29.tar.gz 
```

5. Install Containerlab on each VM
```
bash -c "$(curl -sL https://get.containerlab.dev)" -- -v 0.40.0
```

6. Edit kernel.pid_max in sysctl.conf 
```
vi /etc/sysctl.conf

kernel.pid_max=1048575

sudo sysctl -p
```



