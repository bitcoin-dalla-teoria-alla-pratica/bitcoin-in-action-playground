#!/bin/sh

sh create_p2sh_address_no_signature.sh

ADDR_MITT=`bitcoin-cli getnewaddress "mittente" "legacy"`

#Get P2SH address
ADDR_DEST=`cat address_P2SH.txt`

#Mint 101 blocks and get reward to spend
bitcoin-cli generatetoaddress 101 $ADDR_MITT >> /dev/null
TXID=$(bitcoin-cli listunspent 1 101 '["'$ADDR_MITT'"]' | jq -r '.[0].txid')
VOUT=$(bitcoin-cli listunspent 1 101 '["'$ADDR_MITT'"]' | jq -r '.[0].vout')
AMOUNT=$(bitcoin-cli listunspent 1 101 '["'$ADDR_MITT'"]' | jq -r '.[0].amount-0.001')

#Get sender's PK
PK=`bitcoin-cli dumpprivkey $ADDR_MITT`

printf  "\n \e[31m######### TX_DATA #########\e[39m \n"
TX_DATA=`bitcoin-cli createrawtransaction '[{"txid":"'$TXID'","vout":'$VOUT'}]' '[{"'$ADDR_DEST'":'$AMOUNT'}]'`
bitcoin-cli decoderawtransaction $TX_DATA | jq

printf  "\n \e[31m######### Send transaction and mint 6 blocks #########\e[0m \n"
TX_DATA_SIGNED=$(bitcoin-cli signrawtransactionwithkey $TX_DATA '["'$PK'"]' | jq -r '.hex')
TXID=`bitcoin-cli sendrawtransaction $TX_DATA_SIGNED`
bitcoin-cli generatetoaddress 6 $ADDR_MITT

printf  "\n \e[31m######### spend from P2SH #########\e[39m \n"
AMOUNT=`bitcoin-cli getrawtransaction $TXID 2 | jq -r '.vout[0].value-0.0001'`
VOUT=0
REDEEM=`cat redeem_script.txt`
TX_DATA=$(bitcoin-cli createrawtransaction '[{"txid":"'$TXID'","vout":'$VOUT'}]' '[{"'$ADDR_MITT'":'$AMOUNT'}]')
bitcoin-cli decoderawtransaction $TX_DATA | jq


printf  "\n \e[31m######### Transaction data without scriptSig #########\e[39m \n"
echo $TX_DATA
printf  "\n \e[31m######### Add ScriptSig #########\e[39m \n"

TX_1=`printf $TX_DATA | cut -c 1-82`

REDEEM_SCRIPT=`cat redeem_script.txt`
REDEEM_SCRIPT_LENGTH=$(sh char2hex.sh $(printf $REDEEM_SCRIPT | wc -c)) #22

PASS_SHA=$(printf $1 | openssl dgst -sha256 | awk '{print $2}')
LENGTH_PASS=$(sh char2hex.sh $(printf $PASS_SHA | wc -c)) #20

SCRIPTSIG=$LENGTH_PASS$PASS_SHA$REDEEM_SCRIPT_LENGTH$REDEEM_SCRIPT
SCRIPTSIG_LENGTH=$(sh char2hex.sh $(printf $SCRIPTSIG | wc -c)) #22
#TX_SCRIPTSIG=44202c0a7a036ee138fe1e207676c436f6048703076cc6b8525a0ee3b84638976f0f22202c0a7a036ee138fe1e207676c436f6048703076cc6b8525a0ee3b84638976f0f87
TX_SCRIPTSIG=$SCRIPTSIG_LENGTH$SCRIPTSIG

echo $TX_SCRIPTSIG
echo "-----"

#Until the end
TX_2=$(printf $TX_DATA | cut -c 85-)

echo $TX_1$TX_SCRIPTSIG$TX_2

printf  "\n \e[31m######### Send transaction #########\e[0m\n\n"
TX_DATA=$(bitcoin-cli sendrawtransaction $TX_1$TX_SCRIPTSIG$TX_2)

if [[ -n $2 ]] ; then
  btcdeb --tx=$(printf $TX_1$TX_SCRIPTSIG$TX_2) --txin=$(bitcoin-cli getrawtransaction $TXID)
fi

printf  "\n \e[31m######### Mint 6 blocks #########\e[0m\n\n"
bitcoin-cli generatetoaddress 6 $ADDR_MITT
