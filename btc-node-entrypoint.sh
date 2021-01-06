#!/bin/bash

if [ -n "$1" ]; then
    exec "$@"
else
    apt-get update && apt-get install -y jq net-tools
    chmod +x /usr/bin/bitcoin-cli
    chmod +x /usr/bin/bitcoind
    exec bitcoind
fi