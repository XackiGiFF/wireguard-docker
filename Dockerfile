ARG ubuntu_codename=bionic

FROM ubuntu:${ubuntu_codename}

ENV DEBIAN_FRONTEND="noninteractive"
ARG ubuntu_codename=bionic

RUN echo "deb http://archive.ubuntu.com/ubuntu/ ${ubuntu_codename} main" > /etc/apt/sources.list &&\
    echo "deb http://archive.ubuntu.com/ubuntu/ ${ubuntu_codename}-updates main" >> /etc/apt/sources.list &&\
    cat /etc/apt/sources.list &&\
    apt-get update &&\
    apt-get install --yes --no-install-recommends \
    gnupg iproute2 iptables ifupdown iputils-ping make gcc cpp binutils dkms kmod &&\
    apt-get clean && rm -rf /var/lib/apt/lists/*


RUN apt-get update &&\
    apt-get install --yes --no-install-recommends wireguard iptables nano net-tools linux-headers-$(uname -r) &&\
    apt-get clean && rm -rf /var/lib/apt/lists/* &&\
    dkms uninstall wireguard/$(dkms status | awk -F ', ' '{ print $2 }')

WORKDIR /scripts
ENV PATH="/scripts:${PATH}"
COPY install-module /scripts
COPY run /scripts
COPY genkeys /scripts
COPY net-up /scripts
COPY net-down /scripts
RUN chmod 755 /scripts/*

CMD ["run"]
