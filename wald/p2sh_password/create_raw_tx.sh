#!/bin/bash

TXID_WITH_MATURITY=$1
REDEEM_SCRIPT_INPUT_DATA=$2 # SHA256(fegatini)
REDEEM_SCRIPT=$3
BENEFICIARIO=$4

############# COSTRUZIONE TX CHE RISCATTA UTXO P2SH

# Recuperiamo tutti i dettagli
TX_WITH_MATURITY=`bitcoin-cli getrawtransaction $TXID_WITH_MATURITY 2`
# Recuperiamo la UTXO
P2SH_UTXO=`echo $TX_WITH_MATURITY | jq '.vout[0]'`
# Recuperiamo l'indice della UTXO
P2SH_UTXO_INDEX=`echo $P2SH_UTXO | jq -r '.n'`
# Recuperiamo l'ammontare di bitcoin disponibili per la UTXO
P2SH_UTXO_AVAILABLE_AMOUNT=`echo $P2SH_UTXO | jq -r '.value'`
# Sottraiamo la fee destinata al miner
AMOUNT=`printf $P2SH_UTXO_AVAILABLE_AMOUNT | jq '. -0.001'`

# Creiamo una transazione template che utilizza la UTXO P2SH e riscatta il saldo al destinatario
TX_TEMPLATE=$(bitcoin-cli createrawtransaction '[{"txid":"'$TXID_WITH_MATURITY'","vout":'$P2SH_UTXO_INDEX'}]' '[{"'$BENEFICIARIO'":'$AMOUNT'}]')

# Recuperiamo l'intestazione esadecimale della transazione di input
# che contiene la UTXO P2SH
TX_1=`printf $TX_TEMPLATE | cut -c 1-82`

# Costruisco lo ScriptSig
SCRIPT_SIG=`btcc $REDEEM_SCRIPT_INPUT_DATA $REDEEM_SCRIPT`
SCRIPT_SIG_SERIALIZED=`btcc $SCRIPT_SIG`

# Recuperiamo l'intestazione esadecimale della transazione di output
# che contiene BENEFICIARIO
TX_2=$(printf $TX_TEMPLATE | cut -c 85-)

# Costruiamo l'esadecimale completo della transazione che
# riscatta i fondi del P2SH dimostrando di conoscere lo script
# e li invia ad BENEFICIARIO
TX_RAW=$TX_1$SCRIPT_SIG_SERIALIZED$TX_2

echo $TX_RAW
