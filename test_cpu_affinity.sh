#!/bin/bash

# Aim: test the processor affinity 
#  This test uses 2 Nodes with 4 tasks each in exclusive mode

s=$(basename -- "$0")
resultsfile="results."${s%.*}
temporaryfile=affinity.out

affinity_check() {
  while read result
  do
    cpu=${result#*.}
    task=${result%.*}
    # Node 1 
    if [ $task -lt 4 ]; then
      if [ $task -ne $cpu ]; then
         echo FAILED: cpu affinity binding node 1 $task:$cpu >> $resultsfile
         #break
      fi
    fi
    # Node 2
    if [ $task -ge 4 ]; then
      if [ $task -ne $((cpu + 4)) ]; then
         echo FAILED: cpu affinity binding node 2 $task:$cpu >> $resultsfile
         #break
      fi  
    fi  

  done < $1
}

date > $resultsfile

# compile affinity code
module load mpi/mvapich2-2.3a_gcc
export MV2_ENABLE_AFFINITY=0
cd affinity
make
cd ..

salloc -N 2 --exclusive --ntasks-per-node=4 srun --mpi=pmi2 affinity/get_cpu > $temporaryfile

echo "MV2_ENABLE_AFFINITY="$MV2_ENABLE_AFFINITY | tee -a $resultsfile
affinity_check $temporaryfile
