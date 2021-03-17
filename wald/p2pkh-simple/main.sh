printf  "\n \e[34m######### creo il wallet #########\e[0m \n"
bitcoin-cli createwallet "hansel"

printf  "\n \e[31m######### Creo l address del mittente e del destinatario #########\e[0m \n"


ADDR_MITT=$(bitcoin-cli getnewaddress 'mitt' 'legacy')
echo "Address Mittente"
echo $ADDR_MITT

sleep 3

ADDR_DEST=$(bitcoin-cli getnewaddress 'dest' 'legacy')

printf "\nAddress Destinatario\n"
echo $ADDR_DEST

sleep 3

printf  "\n \e[32m######### Mino 101 blocchi #########\e[0m \n"
bitcoin-cli generatetoaddress 101 $ADDR_MITT > /dev/null

sleep 3

printf  "\n \e[33m######### Creo la transazione #########\e[0m \n"
UTXO=$(bitcoin-cli listunspent | jq -r .[0])

TXID=$(bitcoin-cli -named sendtoaddress address="$ADDR_DEST" amount=$(echo $UTXO | jq -r .amount) fee_rate=25 subtractfeefromamount=true)
echo $TXID

if [[ -n $1 ]] ; then
	btcdeb --tx=$(bitcoin-cli getrawtransaction $TXID) --txin=$(bitcoin-cli getrawtransaction $(echo $UTXO | jq -r .txid))
fi
