#!/bin/bash

# Aim: test the processor affinity 
s=$(basename -- "$0")
resultsfile="results."${s%.*}
temporaryfile=affinity.out

affinity_check() {
  while read result
  do
    proc=${result#*.}
    cpu=${result%.*}
    echo "proc" $proc
    echo "cpu" $cpu 
    if [ $proc -ne $cpu ]; then
       echo FAILED: cpu affinity binding > $resultsfile
       break
    fi
  done < $1
}

date > $resultsfile

# compile affinity code
module load mpi/mvapich2-2.3a_gcc
cd affinity
make
cd ..

salloc -N 2 --exclusive --ntasks-per-node=4 srun --mpi=pmi2 affinity/get_cpu > $temporaryfile

echo $MV_ENABLE_AFFINITY
affinity_check $temporaryfile
