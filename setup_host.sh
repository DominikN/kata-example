#!/bin/bash
set -e

apt-get update
apt-get install -y \
        htop build-essential xz-utils git iptables \
        apt-transport-https ca-certificates software-properties-common curl wget

# install husarnet

curl https://install.husarnet.com/install.sh | sudo bash

# install docker

curl -sL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
arch=$(dpkg --print-architecture)
sudo -E add-apt-repository "deb [arch=${arch}] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo -E apt-get update
sudo -E apt-get -y install docker-ce

# install kata

ARCH=$(arch)
BRANCH="${BRANCH:-master}"
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/katacontainers:/releases:/${ARCH}:/${BRANCH}/xUbuntu_$(lsb_release -rs)/ /' > /etc/apt/sources.list.d/kata-containers.list"
curl -sL  http://download.opensuse.org/repositories/home:/katacontainers:/releases:/${ARCH}:/${BRANCH}/xUbuntu_$(lsb_release -rs)/Release.key | sudo apt-key add -
sudo -E apt-get update
sudo -E apt-get -y install kata-runtime kata-proxy kata-shim

# configure `docker` and `kata-runtime`

sudo mkdir -p /etc/docker
cat <<EOF | tee /etc/docker/daemon.json
{
  "default-runtime": "kata-runtime",
  "runtimes": {
    "kata-runtime": {
      "path": "/usr/bin/kata-runtime"
    }
  }
}
EOF

# TODO: add kernel with iptables and FUSE support needed by Husarnet: https://github.com/kata-containers/documentation/blob/master/Developer-Guide.md#install-guest-kernel-images

sudo systemctl daemon-reload
sudo systemctl restart docker
