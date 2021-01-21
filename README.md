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
-v dckrtest_v:/var/lib/husarnet \
-v /dev/net/tun:/dev/net/tun \
--cap-add NET_ADMIN \
--sysctl net.ipv6.conf.all.disable_ipv6=0 \
kata-example
```

(if hostname inside container doesn't work, use `-h my-container-1`)