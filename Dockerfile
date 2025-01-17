ARG ubuntu_codename=jammy

FROM ubuntu:${ubuntu_codename}

ENV DEBIAN_FRONTEND="noninteractive"
ARG ubuntu_codename=jammy

RUN echo "deb http://archive.ubuntu.com/ubuntu/ ${ubuntu_codename} main restricted" > /etc/apt/sources.list &&\
    echo "deb http://archive.ubuntu.com/ubuntu/ ${ubuntu_codename}-updates main restricted" >> /etc/apt/sources.list &&\
    echo "deb http://archive.ubuntu.com/ubuntu/ ${ubuntu_codename} universe" >> /etc/apt/sources.list &&\
    echo "deb http://archive.ubuntu.com/ubuntu/ ${ubuntu_codename}-updates universe" >> /etc/apt/sources.list &&\
    cat /etc/apt/sources.list &&\
    apt-get update -y && apt-get upgrade -y&&\
    apt-get install --yes --no-install-recommends \
    gnupg iproute2 iptables ifupdown iputils-ping make gcc cpp binutils dkms kmod &&\
    apt-get clean && rm -rf /var/lib/apt/lists/*


RUN apt-get install --yes --no-install-recommends wireguard-tools iptables nano net-tools

WORKDIR /scripts
ENV PATH="/scripts:${PATH}"
COPY install-module /scripts
COPY run /scripts
COPY genkeys /scripts
COPY net-up /scripts
COPY net-down /scripts
RUN chmod 755 /scripts/*

CMD ["run"]
