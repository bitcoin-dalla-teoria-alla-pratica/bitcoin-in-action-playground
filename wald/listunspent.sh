#!/bin/bash
bitcoin-cli listunspent | jq '.[] | "txid: \(.txid) address: \(.address) amount: \(.amount) confirmations: \(.confirmations)"'
