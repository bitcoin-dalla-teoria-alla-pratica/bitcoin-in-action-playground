#!/bin/bash

TXID_WITH_MATURITY=$1
REDEEM_SCRIPT_INPUT_DATA=$2 # SHA256(fegatini)
REDEEM_SCRIPT=$3
BENEFICIARIO=$4

#### Recuperiamo tutti i dati necessari

# Il JSON della UTXO della transazione
P2SH_UTXO=`bitcoin-cli getrawtransaction $TXID_WITH_MATURITY 2 | jq '.vout[0]'`
# dal quale recuperiamo...
# ...l'indice della UTXO
P2SH_UTXO_INDEX=`echo $P2SH_UTXO | jq -r '.n'`
# ...l'ammontare di bitcoin disponibili per la UTXO
P2SH_UTXO_AVAILABLE_AMOUNT=`echo $P2SH_UTXO | jq -r '.value'`

if [[ -n $5 ]] ; then
    AMOUNT=$5
else
    # Se non e' stato specificato un ammontare specifico da inviare
    # calcoliamo l'ammontare di bitcoin per il beneficiario
    # sottraendo una fee standard per regtest destinata al miner
    AMOUNT=`printf $P2SH_UTXO_AVAILABLE_AMOUNT | jq '. -0.001'`
fi

# Costruisco lo ScriptSig
# In questo passaggio il REDEEM_SCRIPT viene "serializzato"
# diventando una semplice operazione di push bytes sullo stack
# da utilizzare durante la verifica dello ScriptPubKey
SCRIPT_SIG=`btcc $REDEEM_SCRIPT_INPUT_DATA $REDEEM_SCRIPT`

#### Costruzione della TX

# Creiamo una transazione template che utilizza la UTXO P2SH e riscatta il saldo al destinatario attivando RBF del BIP-125
TX_TEMPLATE=$(bitcoin-cli createrawtransaction '[{"txid":"'$TXID_WITH_MATURITY'","vout":'$P2SH_UTXO_INDEX'}]' '[{"'$BENEFICIARIO'":'$AMOUNT'}]' 0 true)

# Recuperiamo l'intestazione esadecimale della transazione di input
# che contiene la UTXO P2SH
TX_1=`printf $TX_TEMPLATE | cut -c 1-82`

# Recuperiamo l'intestazione esadecimale della transazione di output
# che contiene BENEFICIARIO
TX_2=$(printf $TX_TEMPLATE | cut -c 85-)

# Quando si va ad aggiungere lo ScriptSig
# ad una transazione bisogna prependerlo con
# un valore esadecimale che ne indica la quantita' di byte
SCRIPT_SIG_WITH_LENGTH=`btcc $SCRIPT_SIG`

# Costruiamo l'esadecimale completo della transazione che
# riscatta i fondi del P2SH dimostrando di conoscere lo script
# e li invia ad BENEFICIARIO
TX_RAW=$TX_1$SCRIPT_SIG_WITH_LENGTH$TX_2

echo $TX_RAW
