#!/bin/sh

PASSWORD=$1
PASS_SHA=$(printf $PASSWORD | openssl dgst -sha256 | awk '{print $2}')
# Calcoliamo la lunghezza in byte della password
LENGTH_PASS=$(char2hex.sh $(printf $PASS_SHA | wc -c))
OP_EQUAL=87

SCRIPT=$LENGTH_PASS$PASS_SHA$LENGTH_PASS$PASS_SHA$OP_EQUAL

# Salviamo su file per usarlo in main.sh
printf $SCRIPT > script.txt
printf "\e[46m ---------- Bitcoin script in versione esadecimale --------- \e[49m\n"
cat script.txt

# Calcoliamo il RIPEMD-160
SCRIPT_SHA=`printf $SCRIPT | xxd -r -p | openssl sha256| sed 's/^.* //'`
SCRIPT_RIPEMD160=`printf $SCRIPT_SHA |xxd -r -p | openssl ripemd160 | sed 's/^.* //'`

# Calcoliamo l'address P2SH
VERSION_PREFIX_ADDRESS=C4
printf "\n \n\e[46m ---------- ADDRESS P2SH --------- \e[49m\n"
PS2H_ADDR=`printf $VERSION_PREFIX_ADDRESS$SCRIPT_RIPEMD160 | xxd -p -r | base58 -c`
# Salviamo su file per usarlo in main.sh
echo $PS2H_ADDR > address_P2SH.txt
echo $PS2H_ADDR