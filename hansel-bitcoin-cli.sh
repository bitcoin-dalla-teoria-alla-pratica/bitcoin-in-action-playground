#!/bin/bash

if ! command -v bitcoin-cli &> /dev/null
then
    ./bitcoin-core/bin/bitcoin-cli -datadir=hansel $@
else
    bitcoin-cli -datadir=hansel $@
fi