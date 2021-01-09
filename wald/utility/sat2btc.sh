#!/bin/sh
#file sh satoshi to btc
echo "$(echo "ibase=16; $(echo $(printf $1 | tac -rs ..) | tr '[:lower:]' '[:upper:]') " | bc)*10^-08" | bc -l
