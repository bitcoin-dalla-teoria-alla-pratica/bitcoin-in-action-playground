#!/bin/bash
STEP_BASE_URL="https://playground.bitcoininaction.com/bitcoin-smart-contract-101"

STEP="#specifiche-in-pseudo-codifica"
echo "$STEP_BASE_URL$STEP"
PWD_DOUBLE_SHA256=`printf 'fegatini' | sha256sum | xxd -r -p | sha256sum -b | awk '{print $1}'`
echo -e "PWD_DOUBLE_SHA256: $PWD_DOUBLE_SHA256\n"

STEP="#scriptsig-design-suddivisione-dello-script-in-due-parti"
echo "$STEP_BASE_URL$STEP"
REDEEM_SCRIPT="OP_SHA256 $PWD_DOUBLE_SHA256 OP_EQUAL"
echo -e "REDEEM_SCRIPT: $REDEEM_SCRIPT\n"

STEP="#parametri-di-input-del-redeem-script-necessari-ad-eseguire-la-business-logic"
echo "$STEP_BASE_URL$STEP"
PWD_SHA256=`printf 'fegatini' | sha256sum | awk '{print $1}'`
echo -e "PWD_SHA256: $PWD_SHA256\n"

STEP="#btcc-e-un-bitcoin-script-compiler"
echo "$STEP_BASE_URL$STEP"
COMPILED=`btcc $PWD_SHA256 $REDEEM_SCRIPT`
echo -e "COMPILED: $COMPILED\n"

STEP="#btcc-e-un-bitcoin-script-compiler"
echo "$STEP_BASE_URL$STEP"
REDEEM_SCRIPT_COMPILED=`btcc $REDEEM_SCRIPT`
echo -e "REDEEM_SCRIPT_COMPILED: $REDEEM_SCRIPT_COMPILED\n"

STEP="#sha-256-ripemd-160"
echo "$STEP_BASE_URL$STEP"
SCRIPT_SHA256=`printf $REDEEM_SCRIPT_COMPILED | xxd -r -p | openssl sha256 | sed 's/^.* //'`
SCRIPT_RIPEMD160=`printf $SCRIPT_SHA256 | xxd -r -p | openssl ripemd160 | sed 's/^.* //'`
echo -e "SCRIPT_RIPEMD160: $SCRIPT_RIPEMD160\n"

STEP="#indirizzo-bitcoin"
echo "$STEP_BASE_URL$STEP"
P2SH_ADDR=`printf c4$SCRIPT_RIPEMD160 | xxd -p -r | base58 -c`
echo -e "P2SH_ADDR: $P2SH_ADDR\n"

STEP="#pubblicazione-di-una-transazione-che-invia-bitcoin-allindirizzo-bitcoin-vincolando-la-utxo-allo-script-hash"
echo "$STEP_BASE_URL$STEP"
bitcoin-cli generatetoaddress 101 $P2SH_ADDR

STEP="#indirizzo-del-beneficiario"
echo "$STEP_BASE_URL$STEP"
BENEFICIARIO=`bitcoin-cli getnewaddress`
echo -e "BENEFICIARIO: $BENEFICIARIO\n"

STEP="#selezione-della-transazione-che-contiene-la-utxo-p-2-sh"
echo "$STEP_BASE_URL$STEP"
bitcoin-cli importaddress $P2SH_ADDR fegatini
TXID_WITH_MATURITY=`bitcoin-cli listunspent 100 101 "[\"$P2SH_ADDR\"]" | jq -r '.[0].txid'`
echo -e "TXID_WITH_MATURITY: $TXID_WITH_MATURITY\n"

STEP="#creazione-della-transazione-che-esegue-lo-smart-contract"
echo "$STEP_BASE_URL$STEP"
cd /opt/wald/p2sh_password
SC_RAW_TX=`./create_raw_tx.sh $TXID_WITH_MATURITY $PWD_SHA256 $REDEEM_SCRIPT_COMPILED $BENEFICIARIO`
echo -e "SC_RAW_TX: $SC_RAW_TX\n"

STEP="#qa-transazione-che-esegue-smart-contract-prima-di-inviarla-ai-nodi"
echo "$STEP_BASE_URL$STEP"
RAW_TX_WITH_MATURITY=`bitcoin-cli getrawtransaction $TXID_WITH_MATURITY`
echo -e "RAW_TX_WITH_MATURITY: $RAW_TX_WITH_MATURITY\n"

STEP="#invio-della-transazione-alla-rete"
echo "$STEP_BASE_URL$STEP"
SC_TX_ID=`bitcoin-cli sendrawtransaction $SC_RAW_TX`
echo -e "SC_RAW_TX: $SC_TX_ID\n"