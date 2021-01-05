#!/bin/bash

echo "==== btc-node-1"
docker exec -ti dlc_btc-node1_1 $1

echo "==== btc-node-2"
docker exec -ti dlc_btc-node2_1 $1

echo "==== btc-node-3"
docker exec -ti dlc_btc-node3_1 $1