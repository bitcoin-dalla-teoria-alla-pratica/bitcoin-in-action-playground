#!/bin/bash

set -e

function on_sig_term() {
    bitcoin-cli stop
}

trap on_sig_term SIGTERM

if ! command -v base58 &> /dev/null
then
    apt-get update
    apt-get install -y \
        autoconf \
        build-essential \
        bc \
        curl \
        git \
        wget \
        jq \
        libssl-dev \
        libtool \
        net-tools \
        openssl \
        python-pip \
        pkg-config \
        procps \
        sed \
        vim \
        xxd
    pip install base58
fi

# btcdeb setup
if ! command -v btcdeb &> /dev/null
then
    cd /opt
    wget https://github.com/bitcoin-core/btcdeb/archive/0.3.20.tar.gz
    tar -xzf 0.3.20.tar.gz
    cd btcdeb-0.3.20
    chmod +x ./autogen.sh
    ./autogen.sh
    chmod +x  ./configure
    ./configure
    make
    make install
fi

# bitcoin core setup
chmod +x /usr/bin/bitcoin-cli
chmod +x /usr/bin/bitcoind

# bizantino utility
if ! command -v hello.sh &> /dev/null
then
    # for docker exec PATH
    rm -Rf /usr/local/sbin
    ln -s /opt/wald/utility /usr/local/sbin
fi

# libbitcoin explorer
# https://github.com/libbitcoin/libbitcoin-explorer/wiki
if ! command -v bx &> /dev/null
then
    cd /opt/wald/utility
    wget https://github.com/libbitcoin/libbitcoin-explorer/releases/download/v3.2.0/bx-linux-x64-qrcode
    mv bx-linux-x64-qrcode bx
    chmod +x bx
fi

cd

# foreground bitcoin daemon
bitcoind
