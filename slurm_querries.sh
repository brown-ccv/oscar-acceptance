#!/bin/bash
# Aim test all the querry commands associatd with slurm
# note if myquota is failing because of sudo this test script will hang


resultsfile=slurmquerry.out

is_success() {
  #echo $1
  if [ $1 -ne 0 ]; then
     echo "test failed: " $2 >> $resultsfile
  else
     #echo '.' >> $resultsfile
     echo 'test passed: ' $2 >> $resultsfile
  fi
}

$date > $resultsfile 

# Slurm commands
commands=("myq" "squeue" "nodes" "nodestat" "condos" "myquota")
for i in "${commands[@]}"
do
   $i 
   is_success $? $i
done


# How to exit from interact?
#commands=("interact -t1")
#for i in "${commands[@]}"
#do
#   ($i; exit)
#   
#done
