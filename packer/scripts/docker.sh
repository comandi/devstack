#!/bin/bash

## Enable swap and cgroup accounting
echo 'GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"' >> /etc/default/grub
update-grub

# Install docker
wget -qO- 'https://get.docker.com/gpg' | sudo apt-key add -
wget -qO- 'https://get.docker.com' | sudo sh

echo 'DOCKER_OPTS="--userland-proxy=false"' >> /etc/default/docker
gpasswd -a ${USER} docker
usermod -aG docker vagrant

service docker stop

mkdir -p /etc/systemd/system
tee /etc/systemd/system/docker.service >/dev/null <<'EOF'
[Service]
ExecStart=
ExecStart=/usr/bin/docker daemon \
            -H fd:// \
            --log-driver=json-file --log-opt max-size=25m --log-opt max-file=2
EOF

mkdir -p /usr/local/bin

curl -Lo /usr/local/bin/docker-compose https://github.com/docker/compose/releases/download/1.6.0/docker-compose-`uname -s`-`uname -m` 
chmod +x /usr/local/bin/docker-compose

