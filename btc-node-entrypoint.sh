#!/bin/bash

apt-get update && apt-get install -y jq

if [ -n "$1" ]; then
    echo "exec command $1"
    exec "$@"
else
    echo "exec bitcoind"
    exec bitcoind
fi