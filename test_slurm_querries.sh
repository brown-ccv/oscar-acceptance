#!/bin/bash
# Aim test all the querry commands associatd with slurm
# note if myquota is failing because of sudo this test script will hang


resultsfile=slurmquerry.out

is_success() {
  #echo $1
  if [ $1 -ne 0 ]; then
     echo "FAILED: " $2 >> $resultsfile
  else
     #echo '.' >> $resultsfile
     echo 'test passed: ' $2 >> $resultsfile
  fi
}

$date > $resultsfile 

# Slurm commands
commands=("myq" "squeue" "nodes" "nodestat" "condos" "condo" "myquota")
for i in "${commands[@]}"
do
   $i 
   is_success $? $i
done

