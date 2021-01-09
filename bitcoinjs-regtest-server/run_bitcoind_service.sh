#!/usr/bin/env bash

function on_sig_term() {
    echo "====> $(date) RICEVUTO SIGTERM <===="
    bitcoin-cli stop
}

trap on_sig_term SIGTERM

/usr/bin/bitcoind -server -regtest -txindex -zmqpubhashtx=tcp://127.0.0.1:30001 -zmqpubhashblock=tcp://127.0.0.1:30001 -rpcworkqueue=32 &
disown
#sleep 2
#/usr/bin/bitcoin-cli -regtest generate 432