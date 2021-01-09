#!/bin/bash

ADDR_MITT=`bitcoin-cli getnewaddress "mittente" "legacy"`

#Get P2SH password address
sh create_p2sh_address_no_signature.sh $1
ADDR_DEST=`cat address_P2SH.txt`

bitcoin-cli importaddress $ADDR_DEST
#Mint 101 blocks and get reward to spend
#printf  "\n \e[31m######### spend from P2SH #########\e[39m \n"
bitcoin-cli generatetoaddress 101 $ADDR_DEST >> /dev/null
TXID=$(bitcoin-cli listunspent 1 101 '["'$ADDR_DEST'"]' | jq -r '.[0].txid')
VOUT=$(bitcoin-cli listunspent 1 101 '["'$ADDR_DEST'"]' | jq -r '.[0].vout')
AMOUNT=$(bitcoin-cli listunspent 1 101 '["'$ADDR_DEST'"]' | jq -r '.[0].amount-0.001')

printf  "\n \e[31m######### TX con UTXO P2SH #########\e[39m\n\n"
echo "http://localhost:8094/regtest/tx/$TXID"

TX_DATA=$(bitcoin-cli createrawtransaction '[{"txid":"'$TXID'","vout":'$VOUT'}]' '[{"'$ADDR_MITT'":'$AMOUNT'}]')
#bitcoin-cli decoderawtransaction $TX_DATA | jq


#printf  "\n \e[31m######### Transaction data without scriptSig #########\e[39m \n"
#echo $TX_DATA
#printf  "\n \e[31m######### Add ScriptSig #########\e[39m \n"

TX_1=`printf $TX_DATA | cut -c 1-82`

REDEEM_SCRIPT=`cat redeem_script.txt`
REDEEM_SCRIPT_LENGTH=$(char2hex.sh $(printf $REDEEM_SCRIPT | wc -c))

SCRIPTSIG=$REDEEM_SCRIPT_LENGTH$REDEEM_SCRIPT
SCRIPTSIG_LENGTH=$(char2hex.sh $(printf $SCRIPTSIG | wc -c))

TX_SCRIPTSIG=$SCRIPTSIG_LENGTH$SCRIPTSIG

#printf  "\n \e[31m######### Transaction scriptSig #########\e[39m \n"
#echo $TX_SCRIPTSIG

TX_2=$(printf $TX_DATA | cut -c 85-)

TX_RAW=$TX_1$TX_SCRIPTSIG$TX_2

#printf  "\n \e[31m######### Transaction RAW #########\e[39m \n"
#echo $TX_RAW

#printf  "\n \e[31m######### Send transaction #########\e[0m\n\n"
TX_DATA=$(bitcoin-cli sendrawtransaction $TX_RAW)
printf  "\n \e[31m######### USA PASSWORD PER RISCATTARE SALDO P2SH #########\e[0m\n\n"
echo "http://localhost:8094/regtest/tx/$TX_DATA"

if [[ -n $2 ]] ; then
  btcdeb --tx=$(printf $TX_RAW) --txin=$(bitcoin-cli getrawtransaction $TXID)
fi

#printf  "\n \e[31m######### Mint 1 blocks #########\e[0m\n\n"
bitcoin-cli generatetoaddress 1 $ADDR_MITT >> /dev/null
