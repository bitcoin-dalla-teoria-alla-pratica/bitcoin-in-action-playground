#!/bin/bash
INET_FULL=`ifconfig | grep 'inet 172'`
echo -n "my inet: "
echo $INET_FULL | awk '{print $2}'

bitcoin-cli getpeerinfo | jq '.[] | "inbound: \(.inbound) addr: \(.addr) addrbind: \(.addrbind) synced_blocks: \(.synced_blocks)"'
