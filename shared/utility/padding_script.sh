#ADD 0 or 00 in order to have positive number and avoid negative (signed magnitude representation)
#convert in HEX and rappresent it in little endian

var=$1


#check if negative
if [ $var -le 0 ];
then
  var="${var:1}"
  HEX=$(echo 'obase=16; '$var'' | bc)
  RES=$(printf $HEX | tac -rs ..)
  #echo $RES
  #exit
fi


#DA FINIRE, BASTEREBBE SOLO L'IF DEL PARI
BIN=$(echo 'obase=2; '$var'' | bc)
HEAD=$(printf $BIN | head -c 1)
HEX=$(echo 'obase=16; '$var'' | bc)
HEXCOUNT=$(printf $HEX | wc -c)

if [ $HEAD -eq 1 ]
then
  if [ $(($HEXCOUNT%2)) -eq 0 ];
  then
      PADDING="00"
      BIN=$PADDING$BIN #debug purpose
      RES=$(printf $PADDING$HEX | tac -rs ..)
  else
      PADDING="0"
      BIN=$PADDING$BIN #debug purpose
      RES=$(printf $PADDING$HEX | tac -rs ..)
  fi

fi

echo $RES
