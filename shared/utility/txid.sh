TRANSACTION_DATA=$1

TXID=$(printf `printf $TRANSACTION_DATA | xxd -r -p | sha256sum -b | xxd -r -p | sha256sum -b` | tac -rs ..)
echo $TXID
