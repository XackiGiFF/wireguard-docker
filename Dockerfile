FROM debian:buster

RUN echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list && \
 printf 'Package: *\nPin: release a=unstable\nPin-Priority: 90\n' > /etc/apt/preferences.d/limit-unstable

RUN echo "deb http://ppa.launchpad.net/wireguard/wireguard/ubuntu ${ubuntu_codename} main" > /etc/apt/sources.list.d/wireguard.list &&\
    echo "deb-src http://ppa.launchpad.net/wireguard/wireguard/ubuntu ${ubuntu_codename} main" >> /etc/apt/sources.list.d/wireguard.list &&\
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E1B39B6EF6DDB96564797591AE33835F504A1A25 &&\
    apt-get update &&\
    apt-get install --yes --no-install-recommends wireguard linux-headers-$(uname -r) &&\
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
