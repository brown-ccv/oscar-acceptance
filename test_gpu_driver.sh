#!/bin/bash

# Aim: check driver version on gpu nodes

s=$(basename -- "$0")
resultsfile="results."${s%.*}
tempfile=temp.out

date > $resultsfile 
rm temp.out

for n in $(sinfo -N -p gpu | awk 'NR>1 {print $1}') 
do
  echo -n $n " driver "
  driver=$(ssh -T $n nvidia-smi | awk 'FNR == 3 {print $6}')
  echo $driver >> $tempfile
done


# check there is only one dirver version on all the nodes.
d=$(uniq $tempfile | wc -l)
if [ $d -eq 1 ]; then
  echo "one driver"
else
  echo "FAILED: " $d " drivers"  >> $resultsfile
fi

