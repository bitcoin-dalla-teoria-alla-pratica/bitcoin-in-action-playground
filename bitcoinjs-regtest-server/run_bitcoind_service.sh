#!/usr/bin/env bash

function on_sig_term() {
    echo "====> $(date) RICEVUTO SIGTERM <===="
    bitcoin-cli stop
}

trap on_sig_term SIGTERM

/usr/bin/bitcoind -zmqpubhashtx=tcp://127.0.0.1:30001 -zmqpubhashblock=tcp://127.0.0.1:30001 -rpcworkqueue=32