#!/bin/sh

  printf  "\n\e[42m ######### P2SH #########\e[49m\n\n"

  PASSWORD=$1
  # barno = 2c0a7a036ee138fe1e207676c436f6048703076cc6b8525a0ee3b84638976f0f
  PASS_SHA=$(printf $PASSWORD | openssl dgst -sha256 | awk '{print $2}')
  LENGTH_PASS=$(char2hex.sh $(printf $PASS_SHA | wc -c)) #20
  OP_EQUAL=87

  #202c0a7a036ee138fe1e207676c436f6048703076cc6b8525a0ee3b84638976f0f87
  SCRIPT=$LENGTH_PASS$PASS_SHA$LENGTH_PASS$PASS_SHA$OP_EQUAL

  printf $SCRIPT > redeem_script.txt
  printf "\e[46m ---------- Redeem Script --------- \e[49m\n"
  cat redeem_script.txt

  printf "\n \n\e[46m ---------- scriptPubKey --------- \e[49m\n"
  ADDR_SHA=`printf $SCRIPT | xxd -r -p | openssl sha256| sed 's/^.* //'`
  ADDR_RIPEMD160=`printf $ADDR_SHA |xxd -r -p | openssl ripemd160 | sed 's/^.* //'`
  printf $ADDR_RIPEMD160 > scriptPubKey.txt
  cat scriptPubKey.txt

  #ADDRESS
  VERSION_PREFIX_ADDRESS=C4
  printf "\n \n\e[46m ---------- 🔑 ADDRESS P2SH --------- \e[49m\n"
  ADDR=`printf $VERSION_PREFIX_ADDRESS$ADDR_RIPEMD160 | xxd -p -r | base58 -c`
  echo $ADDR > address_P2SH.txt
  echo $ADDR
