FROM ubuntu:16.04

LABEL maintainer="Linagora Folks <lgs-openpaas-dev@linagora.com>"
LABEL description="Provides an image with Janus Gateway"

RUN apt-get update -y \
    && apt-get upgrade -y

RUN apt-get install -y \
    build-essential \
    libmicrohttpd-dev \
    libjansson-dev \
    libnice-dev \
    libssl-dev \
    libsofia-sip-ua-dev \
    libglib2.0-dev \
    libopus-dev \
    libogg-dev \
    libini-config-dev \
    libcollection-dev \
    libconfig-dev \
    pkg-config \
    gengetopt \
    libtool \
    autotools-dev \
    automake

RUN apt-get install -y \
    sudo \
    make \
    git \
    doxygen \
    graphviz \
    cmake

RUN cd ~ \
    && git clone https://github.com/cisco/libsrtp.git \
    && cd libsrtp \
    && git checkout v2.0.0 \
    && ./configure --prefix=/usr --enable-openssl \
    && make shared_library \
    && sudo make install

RUN cd ~ \
    && git clone https://github.com/sctplab/usrsctp \
    && cd usrsctp \
    && ./bootstrap \
    && ./configure --prefix=/usr \
    && make \
    && sudo make install

RUN cd ~ \
    && git clone https://github.com/warmcat/libwebsockets.git \
    && cd libwebsockets \
    && git checkout v2.1.0 \
    && mkdir build \
    && cd build \
    && cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr .. \
    && make \
    && sudo make install

RUN cd ~ \
    && git clone -b v0.9.0 https://github.com/meetecho/janus-gateway.git \
    && cd janus-gateway \
    && sh autogen.sh \
    && ./configure --prefix=/opt/janus --disable-websockets --disable-rabbitmq --disable-mqtt --enable-docs --enable-openssl \
    && make CFLAGS='-std=c99' \
    && make && sudo make install 
    # && sudo make configs 

#RUN cp -rp ~/janus-gateway/certs /opt/janus/share/janus

COPY conf/ /opt/janus/etc/janus/

EXPOSE 8088
EXPOSE 10000-10200/udp

CMD /opt/janus/bin/janus 
#--nat-1-1='112.220.26.74'
#CMD /opt/janus/bin/janus --nat-1-1=${DOCKER_IP}
