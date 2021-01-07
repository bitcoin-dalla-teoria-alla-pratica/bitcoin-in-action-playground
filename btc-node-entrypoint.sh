#!/bin/bash

set -e

if [ -n "$1" ]; then
    exec "$@"
else
    apt-get update
    apt-get install -y \
        autoconf \
        base58 \
        bc \
        git \
        jq \
        libssl-dev \
        libtool \
        net-tools \
        openssl \
        sed \
        xxd
    # btcdeb setup
    cd /opt
    git clone git@github.com:bitcoin-core/btcdeb.git
    cd btcdeb
    chmod +x ./autogen.sh
    ./autogen.sh
    chmod +x  ./configure
    ./configure
    make
    make install
    # bitcoin core setup
    chmod +x /usr/bin/bitcoin-cli
    chmod +x /usr/bin/bitcoind

    # foreground bitcoin daemon
    exec bitcoind
fi