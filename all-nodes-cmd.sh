#!/bin/bash

echo "==== hansel-btc"
docker exec -ti playground_hansel-btc_1 $1

echo "==== gretel-btc"
docker exec -ti playground_gretel-btc_1 $1