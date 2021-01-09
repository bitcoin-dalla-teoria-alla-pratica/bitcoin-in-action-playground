#!/bin/bash

function on_sig_term() {
    echo "====> $(date) RICEVUTO SIGTERM <===="
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
fi