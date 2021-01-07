#!/bin/sh

BIN=$(echo "obase=2;$1" | bc)
#echo $BIN

BASE10=$(echo "ibase=2;$(echo $BIN | tail -c 16)" | bc)
#echo $BASE10

#each bit correspond to 512
BIT_ON=$(echo "$BASE10 * 512" | bc)
#echo $BIT_ON

#In a day we have 86400 seconds. Get the next integer
echo "scale=2 ; $BIT_ON / 86400" | bc | awk '{print ($0-int($0)>0)?int($0)+1:int($0)}'
