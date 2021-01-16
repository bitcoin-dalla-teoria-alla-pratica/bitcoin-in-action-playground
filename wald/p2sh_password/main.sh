#!/bin/bash

if [ -z "$1" ]; then
echo "inserisci la password per sbloccare la transazione!"
exit
fi
PASSWORD_HANSEL=$1
PASSWORD_GRETEL=$2

############# COSTRUZIONE P2SH
./create_p2sh_address_no_signature.sh $PASSWORD_HANSEL
ADDR_P2SH=`cat address_P2SH.txt`

############# COSTRUZIONE UTXO P2SH

# Importiamo l'address P2SH nel wallet
bitcoin-cli importaddress $ADDR_P2SH

# Miniamo 101 blocchi impostando il P2SH come beneficiario della coinbase
# servono 100 conferme per raggiungere la coinbase maturity
# https://github.com/bitcoin/bitcoin/blob/master/src/consensus/consensus.h#L19
bitcoin-cli generatetoaddress 101 $ADDR_P2SH >> /dev/null

# recuperiamo la coinbase del primo dei 101 blocchi
# e' l'unica coinbase ad avere raggiunto 100 conferme
TXID=$(bitcoin-cli listunspent 1 101 '["'$ADDR_P2SH'"]' | jq -r '.[0].txid')
VOUT=$(bitcoin-cli listunspent 1 101 '["'$ADDR_P2SH'"]' | jq -r '.[0].vout')
AMOUNT=$(bitcoin-cli listunspent 1 101 '["'$ADDR_P2SH'"]' | jq -r '.[0].amount-0.001')

printf  "\n \e[31m######### TX con UTXO P2SH #########\e[39m\n\n"
echo "http://localhost:8094/regtest/tx/$TXID"



############# COSTRUZIONE TX CHE RISCATTA UTXO P2SH

# Generiamo un indirizzo standard
ADDR_DEST=`bitcoin-cli getnewaddress "destinatario" "legacy"`

# Creiamo una transazione template che utilizza la UTXO P2SH e riscatta il saldo al destinatario
TX_TEMPLATE=$(bitcoin-cli createrawtransaction '[{"txid":"'$TXID'","vout":'$VOUT'}]' '[{"'$ADDR_DEST'":'$AMOUNT'}]')

# Recuperiamo l'intestazione esadecimale della transazione di input
# che contiene la UTXO P2SH
TX_1=`printf $TX_TEMPLATE | cut -c 1-82`

# Recuperiamo il sorgente esadecimale dello script
SCRIPT=`cat script.txt`
# Calcoliamo la lunghezza in byte dello script
SCRIPT_LENGTH=$(char2hex.sh $(printf $SCRIPT | wc -c))

# Lo script sig contiene il sorgente esadecimale
# che consente di riscattare la UTXO P2SH
# al suo interno normalmente si aggiungo eventuali parametri di input
# che non erano noti al momento della creazione dell'address P2SH
# tali parametri vengono usati per aumentare la programmabilita' delle logiche di riscatto
# per lo scopo di questo esempio contiene solo il sorgente esadecimale dello script
PASS_SHA=$(printf $PASSWORD_GRETEL | sha256sum | awk '{print $1}')
LENGTH_PASS=$(char2hex.sh $(printf $PASS_SHA | wc -c)) #20
SCRIPTSIG=$LENGTH_PASS$PASS_SHA$SCRIPT_LENGTH$SCRIPT
SCRIPTSIG_LENGTH=$(char2hex.sh $(printf $SCRIPTSIG | wc -c))
TX_SCRIPTSIG=$SCRIPTSIG_LENGTH$SCRIPTSIG

# Recuperiamo l'intestazione esadecimale della transazione di output
# che contiene ADDR_DEST
TX_2=$(printf $TX_TEMPLATE | cut -c 85-)

# Costruiamo l'esadecimale completo della transazione che
# riscatta i fondi del P2SH dimostrando di conoscere lo script
# e li invia ad ADDR_DEST
TX_RAW=$TX_1$TX_SCRIPTSIG$TX_2



############# PUBBLICAZIONE E DEBUG TX CHE RISCATTA UTXO P2SH

# Inviamo TX_RAW alla rete P2P
TX_DATA=$(bitcoin-cli sendrawtransaction $TX_RAW)
printf  "\n \e[31m######### USA PASSWORD PER RISCATTARE SALDO P2SH #########\e[0m\n\n"
echo -e "http://localhost:8094/regtest/tx/$TX_DATA\n"

# Se viene passato il secondo parametro "debug" a questro script si attiva btcdeb
if [[ -n $DEBUG ]] ; then
  btcdeb --tx=$(printf $TX_RAW) --txin=$(bitcoin-cli getrawtransaction $TXID)
fi

# Miniamo un ulteriore blocco per confermare la transazione TX_RAW
bitcoin-cli generatetoaddress 1 $ADDR_DEST >> /dev/null
