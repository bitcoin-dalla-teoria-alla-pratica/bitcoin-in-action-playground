#!/bin/bash

if [ -n "$1" ]; then
    echo "exec command $1"
    exec "$@"
else
    echo "exec bitcoind"
    exec bitcoind
fi