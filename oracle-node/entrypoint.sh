#!/bin/bash

if [ -n "$1" ]; then
    exec "$@"
else
    cd /opt/oracle
    yarn
    touch /var/log/node.log
    tail -f /var/log/node.log
fi