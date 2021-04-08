#!/usr/bin/env bash

# https://github.com/lightningnetwork/lnd/blob/master/docker/lnd/start-lnd.sh#L64

# exit from script if error was raised.
set -e

# error function is used within a bash function in order to send the error
# message directly to the stderr output and exit.
error() {
    echo "$1" > /dev/stderr
    exit 0
}

# return is used within bash function in order to return the value.
return() {
    echo "$1"
}

# set_default function gives the ability to move the setting of default
# env variable from docker file to the script thereby giving the ability to the
# user override it during container start.
set_default() {
    # docker initialized env variables with blank string and we can't just
    # use -z flag as usually.
    BLANK_STRING='""'

    VARIABLE="$1"
    DEFAULT="$2"

    if [[ -z "$VARIABLE" || "$VARIABLE" == "$BLANK_STRING" ]]; then

        if [ -z "$DEFAULT" ]; then
            error "You should specify default variable"
        else
            VARIABLE="$DEFAULT"
        fi
    fi

   return "$VARIABLE"
}

# Set default variables if needed.
RPCUSER=$(set_default "$RPCUSER" "devuser")
RPCPASS=$(set_default "$RPCPASS" "devpass")
DEBUG=$(set_default "$DEBUG" "debug")
NETWORK=$(set_default "$NETWORK" "simnet")
CHAIN=$(set_default "$CHAIN" "bitcoin")
BACKEND=$(set_default "$BACKEND" "btcd")
BACKEND_RPC_HOST=$(set_default "$BACKEND_RPC_HOST" "blockchain")
HOSTNAME=$(hostname)
if [[ "$CHAIN" == "litecoin" ]]; then
    BACKEND="ltcd"
fi

# CAUTION: DO NOT use the --noseedback for production/mainnet setups, ever!
# Also, setting --rpclisten to $HOSTNAME will cause it to listen on an IP
# address that is reachable on the internal network. If you do this outside of
# docker, this might be a security concern!

BTCD_EXTRA_LND_ARGS=""
if [[ "$BACKEND" == "ltcd" || "$BACKEND" == "btcd" ]]; then
    BTCD_EXTRA_LND_ARGS="--$BACKEND.rpccert"="/rpc/rpc.cert"
fi

BITCOIND_EXTRA_LND_ARGS=""
if [[ "$BACKEND" == "bitcoind" ]]; then
    BITCOIND_EXTRA_LND_ARGS="--$BACKEND.zmqpubrawtx=$BACKEND_ZMQPUBRAWTX --$BACKEND.zmqpubrawblock=$BACKEND_ZMQPUBRAWBLOCK"
fi

exec lnd \
    --noseedbackup \
    "--$CHAIN.active" \
    "--$CHAIN.$NETWORK" \
    "--$CHAIN.node"="$BACKEND" \
    $BTCD_EXTRA_LND_ARGS \
    $BITCOIND_EXTRA_LND_ARGS \
    "--$BACKEND.rpchost"="$BACKEND_RPC_HOST" \
    "--$BACKEND.rpcuser"="$RPCUSER" \
    "--$BACKEND.rpcpass"="$RPCPASS" \
    "--rpclisten=$HOSTNAME:10009" \
    "--rpclisten=localhost:10009" \
    --debuglevel="$DEBUG" \
    "$@"
