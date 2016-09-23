FROM ubuntu:16.04
MAINTAINER Devin Babb <devin.babb@ubnt.com>

VOLUME ["/var/lib/unifi-voip", "/var/log/unifi-voip", "/var/run/unifi-voip", "/usr/lib/unifi-voip/work"]

ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen" > \
    /etc/apt/sources.list.d/21mongodb.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
    
RUN echo "deb http://www.ubnt.com/downloads/unifi-voip/stage/debian stable ubiquiti" > \
    /etc/apt/sources.list.d/100-ubnt.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv 52F815F3

# Avoid ERROR: invoke-rc.d: policy-rc.d denied execution of start.
# RUN echo "#!/bin/sh\nexit 101" > /usr/sbin/policy-rc.d

RUN apt-get update && \
    apt-get install binutils jsvc mongodb-server unifi-voip -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN ln -s /var/lib/unifi-voip /usr/lib/unifi-voip/data
EXPOSE 9080/tcp 9443/tcp

WORKDIR /var/lib/unifi-voip

ENTRYPOINT ["/usr/bin/java", "-Xmx1024M", "-jar", "/usr/lib/unifi-voip/lib/ace.jar"]
CMD ["start"]
