#!/bin/sh

printf  "\n\e[42m ######### P2SH #########\e[49m\n\n"


if [ -z "$1" ]; then
echo "inserisci la password per generare il tuo Redeem Script!"
exit
fi

PASSWORD=$1
PASS_SHA=$(printf $PASSWORD | sha256sum | xxd -r -p | sha256sum -b | awk '{print $1}')


#PASS_SHA=$(printf $1 | sha256sum -b | sha256sum -b | awk '{print $1)'
#PASS_SHA=$(printf $1 | xxd -r -p | sha256sum -b | xxd -r -p | sha256sum -b | awk '{print $1})'


LENGTH_PASS=$(char2hex.sh $(printf $PASS_SHA | wc -c)) #20
OP_EQUAL=87
OP_SHA=A8
SCRIPT=$OP_SHA$LENGTH_PASS$PASS_SHA$OP_EQUAL

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
