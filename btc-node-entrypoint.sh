#!/bin/bash

if [ -n "$1" ]; then
    echo "exec command $1"
    exec "$@"
else
    apt-get update && apt-get install -y jq net-tools
    echo "exec bitcoind"
    exec bitcoind
fi