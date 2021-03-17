#!/bin/bash

docker-compose stop

sudo rm -Rf hansel/regtest
sudo rm -Rf gretel/regtest
sudo rm -Rf bitcoinjs-regtest-server/bitcoin-data/regtest
sudo rm -Rf blockchain-explorer/bitcoin
sudo rm -Rf blockchain-explorer/logs
sudo rm -Rf blockchain-explorer/electrs_bitcoin_db
sudo rm -Rf lightningd/lightning/regtest
sudo rm -Rf lightningd/lightning/bitcoin
sudo rm -Rf lightningd/lightning/lightningd-*.pid

echo "=====> pulizia dei file completata, utilizza docker-compose start/up per avviare il playground <====="
