#!/bin/sh
#Converte la lunghezza di una stringa in Lunghezza espressa in HEX
#Insert char length
#2 chars are 1 byte

LENGTH=2
INPUT=$1

if [ $INPUT -eq 1 ];
then
    INPUT=2
fi

VAL=$(echo $(($INPUT / 2)))
RES=$(echo "obase=16; $VAL" | bc)

#echo $RES
VALLENGTH=$(printf $RES | wc -c)

if [ $VALLENGTH -eq 1 ]
then
  RES="0"$RES
fi

echo $RES
