# kata-example



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