FROM ubuntu:18.04

RUN apt update -y

# install Husarnet client
RUN apt update && \
    apt install -y curl && \
    apt install -y gnupg2 && \
    apt install -y systemd && \
    curl https://install.husarnet.com/install.sh | bash

# some optional modules
RUN apt install vim -y
RUN apt install fonts-emojione -y
RUN apt install iputils-ping -y

COPY init-container.sh /opt
CMD /opt/init-container.sh