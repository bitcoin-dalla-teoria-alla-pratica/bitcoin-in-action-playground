#!/bin/bash

function on_sig_term() {
    echo "====> $(date) RICEVUTO SIGTERM <===="
    TAIL_PID=`ps -ef | grep "oz.log" | grep -v grep | awk '{print $2}'`
    kill -15 $TAIL_PID
    exit 0
}

trap on_sig_term SIGTERM

if [ -n "$1" ]; then
    exec "$@"
else
    yarn
    echo "==========================================================="
    echo "$(date) - Oz container up and running!!" >> /var/log/oz.log
    echo "$(date) - Append to /var/log/oz.log to see message here!" >> /var/log/oz.log
    tail -f /var/log/oz.log
    exit 0
fi