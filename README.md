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

```bash
sudo docker run --rm -it \
--env-file ./.env \
-v dckrtest_v:/var/lib/husarnet \
-v /dev/net/tun:/dev/net/tun \
--cap-add NET_ADMIN \
--sysctl net.ipv6.conf.all.disable_ipv6=0 \
kata-example
```