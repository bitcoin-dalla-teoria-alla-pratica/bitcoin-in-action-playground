#!/bin/bash

set -e
apt-get update
apt-get install -y curl git
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt-get install -y nodejs

if [[ -z "${DOCKER_BUILD}" ]]; then
	# run instead of build
else
	echo "DOCKER_BUILD, no foreground jobs.."
	npm i -D spark-wallet
	exit
fi

# https://github.com/ElementsProject/lightning/blob/master/contrib/startup_regtest.sh#L122
while ! bitcoin-cli ping 2> /tmp/null; do echo "awaiting bitcoind..." && sleep 1; done

DEFAULT_WALLET_LOG=/root/.lightning/wallet.lightningd.log
if [ -f "$DEFAULT_WALLET_LOG" ]; then
    echo "$DEFAULT_WALLET_LOG exists, skip createwallet lightningd"
else
    echo "create wallet default $(date)" > $DEFAULT_WALLET_LOG
    bitcoin-cli -regtest createwallet lightningd >> $DEFAULT_WALLET_LOG 2>&1
    bitcoin-cli --rpcwallet=lightningd getnewaddress >> $DEFAULT_WALLET_LOG 2>&1
fi

lightningd &

while ! lightning-cli getinfo 2> /tmp/null; do echo "awaiting lightningd..." && sleep 1; done

npx spark-wallet -l ~/.lightning/regtest --login fulmine:fulmine --no-tls -i 0.0.0.0

