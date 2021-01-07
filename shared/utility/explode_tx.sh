#!/bin/sh


#Si inserisce la transaction data e viene "esplosa" nelle sue parti piu interessanti.

TX_DATA=$1

#Controllo la versione della transazione
printf "\e[33m Version: `printf $TX_DATA | cut -c 1-8` \n \e[31m"

#Controllo il numero di input
NUM_INPUT=$(echo "ibase=16;`printf $TX_DATA | cut -c 9-10`" | bc)

printf "\e[34m #inputs: $NUM_INPUT \n \e[34m"

INIT=11

printf "\n \e[46m ---------- INPUT --------- \e[49m \n "
C=1

while [[ $C -le $NUM_INPUT ]]
do

TXID_LENGTH=$(expr `echo $INIT+63 | bc`)
TXID_UTXO=$(printf `printf $TX_DATA | cut -c $INIT-$TXID_LENGTH` | tac -rs ..)
printf "\n TXID UTXO di riferimento (32 byte):$TXID_UTXO \n \e[31m"

TXID_LENGTH=$(expr `echo $TXID_LENGTH+1 | bc`)
VOUT_LENGTH=$(expr `echo $TXID_LENGTH+7 | bc`)
VOUT=$(printf $TX_DATA | cut -c $TXID_LENGTH-$VOUT_LENGTH)
printf "\n vout, index della UTXO (4 byte): $VOUT \n \e[36m"


#Verifico che tipo di UTXO è
VOUT_INDEX=`echo "ibase=16; $VOUT" | bc`


UTXO_TYPE=$(bitcoin-cli getrawtransaction $TXID_UTXO 2 | jq -r '.vout['$VOUT_INDEX'].scriptPubKey.type')

printf "\n Tipo di UTXO da sbloccare: $UTXO_TYPE \e[92m \n"

if [ $UTXO_TYPE = 'pubkeyhash' ]
then

    VOUT_LENGTH=$(expr `echo $VOUT_LENGTH+1 | bc`)
    SCRIPTLENGTH=$(expr `echo $VOUT_LENGTH+1 | bc`)
    SCRIPT_LENGTH_HEX=`printf $TX_DATA | cut -c $VOUT_LENGTH-$SCRIPTLENGTH`
    SCRIPT_LENGTH_CHAR=$(expr `echo "ibase=16; $(printf $SCRIPT_LENGTH_HEX | tr '[:lower:]' '[:upper:]')" | bc` "*" 2)
    printf "\n scriptSig length: HEX:$SCRIPT_LENGTH_HEX - caratteri esadecimali da prendere in considerazione:$SCRIPT_LENGTH_CHAR \n \e[92m"

    SCRIPTLENGTH=$(expr `echo $SCRIPTLENGTH+1 | bc`)
    SCRIPTSIG=$(expr `echo $SCRIPTLENGTH+$SCRIPT_LENGTH_CHAR-1 | bc`)

    printf "\n scriptSig: `printf $TX_DATA | cut -c $SCRIPTLENGTH-$SCRIPTSIG` \n \e[92m"

    SIGNATURE=$(expr `echo $SCRIPTLENGTH+1 | bc`)
    SIGNATURE_LENGTH_HEX=`printf $TX_DATA | cut -c $SCRIPTLENGTH-$SIGNATURE`

    SIGNATURE_LENGTH_CHAR=$(expr `echo "ibase=16; $(printf $SIGNATURE_LENGTH_HEX | tr '[:lower:]' '[:upper:]')" | bc` "*" 2)
    printf "\n \t scriptSig signature length: HEX:$SIGNATURE_LENGTH_HEX - caratteri esadecimali da prendere in considerazione:$SIGNATURE_LENGTH_CHAR \n \e[92m"

    SIGNATURE_START=$(expr `echo $SIGNATURE+1 | bc`)
    SIGNATURE_END=$(expr `echo $SIGNATURE+$SIGNATURE_LENGTH_CHAR | bc`)
    printf "\n \t Signature: `printf $TX_DATA | cut -c $SIGNATURE_START-$SIGNATURE_END` \n \e[92m"

    PB_LENGTH_START=$(expr `echo $SIGNATURE_END+1 | bc`)
    PB_LENGTH_END=$(expr `echo $PB_LENGTH_START+1 | bc`)
    PB_LENGTH_LENGTH_HEX=`printf $TX_DATA | cut -c $PB_LENGTH_START-$PB_LENGTH_END`

    PB_LENGTH_LENGTH_CHAR=$(expr `echo "ibase=16; $(printf $PB_LENGTH_LENGTH_HEX | tr '[:lower:]' '[:upper:]')" | bc` "*" 2)
    printf "\n \t scriptSig Public length: HEX:$PB_LENGTH_LENGTH_HEX - caratteri esadecimali da prendere in considerazione:$PB_LENGTH_LENGTH_CHAR \n \e[33m"

    PB_START=$(expr `echo $PB_LENGTH_END+1 | bc`)
    PB_END=$(expr `echo $PB_LENGTH_END+$PB_LENGTH_LENGTH_CHAR | bc`)

    printf "\n \t Public Key: `printf $TX_DATA | cut -c $PB_START-$PB_END` \n \e[95m"

    PB_END=$(expr `echo $PB_END+1 | bc`)
    SEQUENCE=$(expr `echo $PB_END+7 | bc`)
    printf "\n Sequence: `printf $TX_DATA | cut -c $PB_END-$SEQUENCE` \n \e[34m"

    SEQUENCE=$(expr `echo $SEQUENCE+1 | bc`)
    INIT=$SEQUENCE

elif [ $UTXO_TYPE = 'multisig' ]
then
    UTXO=`bitcoin-cli getrawtransaction $TXID_UTXO 2 | jq -r '.vout['$VOUT_INDEX']'`
    REQSIGS=`echo $UTXO | jq -r '.scriptPubKey.reqSigs'`
    printf "\n Firme necessarie per sbloccare UTXO: $REQSIGS \n \e[94m"

    VOUT_LENGTH=$(expr `echo $VOUT_LENGTH+1 | bc`)
    SCRIPTLENGTH=$(expr `echo $VOUT_LENGTH+1 | bc`)
    SCRIPT_LENGTH_HEX=`printf $TX_DATA | cut -c $VOUT_LENGTH-$SCRIPTLENGTH`
    SCRIPT_LENGTH_CHAR=$(expr `echo "ibase=16; $(printf $SCRIPT_LENGTH_HEX | tr '[:lower:]' '[:upper:]')" | bc` "*" 2)
    printf "\n scriptSig length: HEX:$SCRIPT_LENGTH_HEX - caratteri esadecimali da prendere in considerazione:$SCRIPT_LENGTH_CHAR \n \e[91m"

    SCRIPTLENGTH=$(expr `echo $SCRIPTLENGTH+1 | bc`)
    SCRIPTSIG=$(expr `echo $SCRIPTLENGTH+$SCRIPT_LENGTH_CHAR-1 | bc`)
    printf "\n scriptSig: `printf $TX_DATA | cut -c $SCRIPTLENGTH-$SCRIPTSIG` \n \e[94m"

    #BUG OP_CHECKMULTISIG
    OP_0_BUG=$(expr `echo $SCRIPTLENGTH+1 | bc`)
    printf "\n \t scriptSig OP_0 BUG: `printf $TX_DATA | cut -c $SCRIPTLENGTH-$OP_0_BUG` \n \e[94m"

    OP_0_BUG=$(expr `echo $OP_0_BUG+1 | bc`)
    #Aggiungo OP_0, la lunghezza dei char della firma (2) e a lunghezza effettiva
    COUNT_CHAR_SIGNATURE=2

    while [[  $COUNT_CHAR_SIGNATURE  -le $SCRIPT_LENGTH_CHAR ]]
    do
        SIGNATURE_LENGTH_HEX=$(expr `echo $OP_0_BUG+1 | bc`)
        SIGNATURE_LENGTH_HEX=`printf $TX_DATA | cut -c $OP_0_BUG-$SIGNATURE_LENGTH_HEX`
        SIGNATURE_LENGTH_CHAR=$(expr `echo "ibase=16; $(printf $SIGNATURE_LENGTH_HEX | tr '[:lower:]' '[:upper:]')" | bc` "*" 2)
        printf "\n \t \t scriptSig signature length: HEX:$SIGNATURE_LENGTH_HEX - caratteri esadecimali da prendere in considerazione:$SIGNATURE_LENGTH_CHAR \n \e[94m"

        COUNT_CHAR_SIGNATURE=$(($COUNT_CHAR_SIGNATURE + 2 + $SIGNATURE_LENGTH_CHAR))

        SIGNATURE_START=$(expr `echo $OP_0_BUG+2 | bc`)
        SIGNATURE_END=$(expr `echo $OP_0_BUG+$SIGNATURE_LENGTH_CHAR+1 | bc`)
        printf "\n \t \t Signature: `printf $TX_DATA | cut -c $SIGNATURE_START-$SIGNATURE_END` \n \e[94m"

        COUNT_CHAR_SIGNATURE=$(($COUNT_CHAR_SIGNATURE + 2 + $SIGNATURE_LENGTH_CHAR))
        OP_0_BUG=$(expr `echo $SIGNATURE_END+1 | bc`)
    done

    SEQUENCE=$(expr `echo $OP_0_BUG+7 | bc`)
    printf "\n Sequence: `printf $TX_DATA | cut -c $OP_0_BUG-$SEQUENCE` \n \e[34m"

    SEQUENCE=$(expr `echo $SEQUENCE+1 | bc`)
    INIT=$SEQUENCE


    fi

C=$((C+1))
printf "\n --------"
done

printf "\n \e[42m ---------- OUTPUT --------- \e[49m \n "

#Controllo il numero di output
NUM_OUTPUT_LENGTH=$(expr `echo $SEQUENCE+1 | bc`)
NUM_OUTPUT=$(echo "ibase=16;`printf $TX_DATA | cut -c $SEQUENCE-$NUM_OUTPUT_LENGTH`" | bc)

INDEX=0
for (( c=1; c<=$NUM_OUTPUT; c++ ))
do

UTXO_TYPE=$(bitcoin-cli decoderawtransaction $TX_DATA | jq -r '.vout['$INDEX'].scriptPubKey.type')

printf "\n Tipo di UTXO generata: $(bitcoin-cli decoderawtransaction $TX_DATA | jq -r '.vout['$INDEX'].scriptPubKey.type') \e[92m \n"

    if [ $UTXO_TYPE = 'pubkeyhash' ] || [ "$UTXO_TYPE" = "nulldata" ]
    then
        #value 8 bytes
        NUM_OUTPUT_LENGTH=$(expr `echo $NUM_OUTPUT_LENGTH+1 | bc`)
        VALUE_LENGTH=$(expr `echo $NUM_OUTPUT_LENGTH+15 | bc`)
        VALUE_SATOSHI=`printf $TX_DATA | cut -c $NUM_OUTPUT_LENGTH-$VALUE_LENGTH`
        VALUE_BTC=`echo "$(echo "ibase=16; $(echo $(printf $VALUE_SATOSHI | tac -rs ..) | tr '[:lower:]' '[:upper:]') " | bc)*10^-08" | bc -l`
        printf "\n Il value (8 byte, 16 caratteri hex) in satoshi è: $VALUE_SATOSHI - in bitcoin è :$VALUE_BTC \n \e[33m"

        #ScriptPubKey length
        VALUE_LENGTH=$(expr `echo $VALUE_LENGTH+1 | bc`)
        SCRIPTPUBKEY_LENGTH=$(expr `echo $VALUE_LENGTH+1 | bc`)

        SCRIPTPUBKEY_LENGTH_HEX=`printf $TX_DATA | cut -c $VALUE_LENGTH-$SCRIPTPUBKEY_LENGTH`
        SCRIPTPUBKEY_LENGTH_CHAR=$(expr `echo "ibase=16; $(printf $SCRIPTPUBKEY_LENGTH_HEX | tr '[:lower:]' '[:upper:]')" | bc` "*" 2)

        printf "\n scriptPubKey length: HEX:$SCRIPTPUBKEY_LENGTH_HEX - caratteri esadecimali da prendere in considerazione:$SCRIPTPUBKEY_LENGTH_CHAR \n \e[33m"


        #ScriptPubKey
        SCRIPTPUBKEY_LENGTH=$(expr `echo $SCRIPTPUBKEY_LENGTH+1 | bc`)
        SCRIPTPUBKEY=$(expr `echo $SCRIPTPUBKEY_LENGTH+$SCRIPTPUBKEY_LENGTH_CHAR-1 | bc`)
        printf "\n ScriptPubKey: `printf $TX_DATA | cut -c $SCRIPTPUBKEY_LENGTH-$SCRIPTPUBKEY` \e[34m"
        printf "\n ScriptPubKey: `bitcoin-cli decoderawtransaction $TX_DATA | jq -r '.vout['$INDEX'].scriptPubKey.asm'` \n \e[34m"

        NUM_OUTPUT_LENGTH=$SCRIPTPUBKEY

    fi
        INDEX=$((INDEX + 1))
        printf "\n --------"
done

#locktime 4 bytes
SCRIPTPUBKEY=$(expr `echo $SCRIPTPUBKEY+1 | bc`)
LOCKTIME_LENGTH=$(expr `echo $SCRIPTPUBKEY+7 | bc`)



printf "\n \e[42m ------------------- \e[49m \n "
printf "\n Locktime: `printf $TX_DATA | cut -c $SCRIPTPUBKEY-$LOCKTIME_LENGTH` \n \e[95m"
