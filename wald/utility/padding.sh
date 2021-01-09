#8 bytes == 16 hex char
# LENGTH is total length
LENGTH=$1
var=$2

varlength=$(printf $var | wc -c)

if [ $varlength -eq $LENGTH ]
then
  printf $var
  exit
fi

#how many zero pad?
pad=$(echo $(($LENGTH-$varlength)))

#create zero pad
padding=$(printf "%0"$pad"d\n")
printf $padding$var
