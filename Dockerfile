FROM ubuntu:18.04

# install Husarnet client
RUN apt update -y && \
    apt install -y curl && \
    apt install -y gnupg2 && \
    apt install -y systemd && \
    curl https://install.husarnet.com/install.sh | bash

# some optional modules
RUN apt install vim -y
RUN apt install fonts-emojione -y
RUN apt install iputils-ping -y

RUN apt install openssh-server sudo -y
RUN useradd -rm -d /home/johny -g root -G sudo -s /bin/bash -u 123 johny
RUN echo 'johny:johny' | chpasswd
RUN service ssh start

# Find your JOINCODE at https://app.husarnet.com
ENV JOINCODE=""
ENV HOSTNAME=my-container-1

# SSH
EXPOSE 22

COPY init-container.sh /opt
CMD /opt/init-container.sh