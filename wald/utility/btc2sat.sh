#8 bytes == 16 hex char
LENGTH=16

#Multiply
var1=$(echo "$1*10^08" | bc)
#echo "var1 "$var1

#convert to base16
var1=$(echo 'obase=16;' $var1 | bc)
#echo "var1 hex "$var1

#echo "trim dot and zeros"
var1=$(printf $var1 | cut -f1 -d".")
#echo $var1

#how many zero pad?
pad=$(echo $(($LENGTH-$(printf $var1 | wc -c))))
#echo "pad "$var1

#create zero pad
zeros=$(printf "%0"$pad"d\n")
#echo "zeros "$zeros

#big to little endian
sat=$(printf $zeros$var1 | tac -rs ..)

echo $sat
