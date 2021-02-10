# kata-example

## prepare environment

The instruction below was tested on the fresh installation of Ubuntu 20.04

### other

1. Enable nested HW virt support
``` bash
VBoxManage modifyvm "myvm-name" --nested-hw-virt on
```

2. FUSE support:
``` bash
sudo apt-get install libfuse-dev
```

### install `kata-runtime`

(based on [official Kata Documentaion](https://github.com/kata-containers/documentation/blob/master/install/ubuntu-installation-guide.md) )

```bash
sudo apt install curl -y && \
ARCH=$(arch) && \
BRANCH="${BRANCH:-master}" && \
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/katacontainers:/releases:/${ARCH}:/${BRANCH}/xUbuntu_$(lsb_release -rs)/ /' > /etc/apt/sources.list.d/kata-containers.list" && \
curl -sL  http://download.opensuse.org/repositories/home:/katacontainers:/releases:/${ARCH}:/${BRANCH}/xUbuntu_$(lsb_release -rs)/Release.key | sudo apt-key add - && \
sudo -E apt-get update && \
sudo -E apt-get -y install kata-runtime kata-proxy kata-shim
```

### install `docker`

(based on [official Kata Documentaion](https://github.com/kata-containers/documentation/blob/master/install/docker/ubuntu-docker-install.md) )

```bash
sudo -E apt-get -y install apt-transport-https ca-certificates software-properties-common && \
curl -sL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && \
arch=$(dpkg --print-architecture) && \
sudo -E add-apt-repository "deb [arch=${arch}] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
sudo -E apt-get update && \
sudo -E apt-get -y install docker-ce
```

### configure `docker` and `kata-runtime`

1. Create `daemon.json` file:

```bash
$ sudo mkdir -p /etc/docker
$ sudo vim /etc/docker/daemon.json
```

and paste the following content to that file:
```json
{
  "default-runtime": "kata-runtime",
  "runtimes": {
    "kata-runtime": {
      "path": "/usr/bin/kata-runtime"
    }
  }
}
```

And then:
```bash
$ sudo systemctl daemon-reload
$ sudo systemctl restart docker
```

2. Modify `configuration.toml` file:

edit `/usr/share/defaults/kata-containers/configuration.toml` file, and find line:

```
internetworking_model="tcfilter"
```
Modify it to:
```
internetworking_model="macvtap"
```


## build

Make sure `init-container.sh` is executable. If not:
```bash
sudo chmod +x init-container.sh
```

```bash
sudo docker build -t kata-example .
```

## run

create `.env` file in the project main folder with your Husarnet credentials, eg.:
```
JOINCODE=fc94:b01d:1803:8dd8:2222:3333:1234:1234/xxxxxxxxxxxxxxxxxxxxx
HOSTNAME=mydevice1
```

and run:

```bash
sudo docker run --rm -it \
--env-file ./.env \
-v my-container-1-v:/var/lib/husarnet \
-v /dev/net/tun:/dev/net/tun \
--cap-add NET_ADMIN \
--sysctl net.ipv6.conf.all.disable_ipv6=0 \
kata-example
```

TODO: if I run the command in above way, I see a container number instead of hostname, eg. `root@32943104i0`. Running with `--privileged` flag makes the hostname visible in the terminal session, eg. `root@my-container-1`. Temporary solution might be running a container with `-h my-container-1` option. You can still use IPv6 Husarnet address in all cases.

```bash
sudo docker run --rm -it --privileged \
--env-file ./.env \
-v dckrtest_v:/var/lib/husarnet \
--sysctl net.ipv6.conf.all.disable_ipv6=0 \
kata-example
```