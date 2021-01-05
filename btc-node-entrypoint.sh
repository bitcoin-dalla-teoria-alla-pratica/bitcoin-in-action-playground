#!/bin/bash

if [ -n "$1" ]; then
    exec "$@"
else
    apt-get update && apt-get install -y jq net-tools
    exec bitcoind
fi