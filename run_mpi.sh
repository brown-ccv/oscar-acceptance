#!/bin/bash

# Aim: compile and run a hello world for each of the mpi modules
# Test is mpi produces hello world output

#mpi/mvapich2-2.3a_gcc    mpi/openmpi_1.8.3_gcc    mpi/openmpi_2.0.3_pgi    
#mpi/mvapich2-2.3a_intel  mpi/openmpi_2.0.3_gcc    
#mpi/mvapich2-2.3a_pgi    mpi/openmpi_2.0.3_intel  

module load pgi

resultsfile=mpi.results.out

mpi_errors() {
grep -q 'Hello Oscar, I am 0 of 2' $1
if [ $? -ne 0 ]; then
  echo "FAILED " $2 | tee -a $resultsfile
  return
fi

grep -q 'Hello Oscar, I am 1 of 2' $1
if [ $? -ne 0 ]; then
  echo "FAILED " $2 | tee -a $resultsfile
fi
}

date > $resultsfile 

# Slurm commands - pgi has a bug that affects openmpi
#mods=("mpi/mvapich2-2.3a_gcc" "mpi/mvapich2-2.3a_intel" "mpi/mvapich2-2.3a_pgi")
#mods=("mpi/openmpi_2.0.3_gcc"   "mpi/openmpi_2.0.3_intel" "mpi/openmpi_2.0.3_pgi")
mods=("mpi/openmpi_1.8.3_gcc") 
#mods=("mpi/mvapich2-2.3a_intel" "mpi/mvapich2-2.3a_intel" "mpi/mvapich2-2.3a_pgi" \
#      "mpi/openmpi_2.0.3_gcc"   "mpi/openmpi_2.0.3_intel" "mpi/openmpi_2.0.3_pgi" \
#      "openmpi_1.8.3_gcc")

for i in "${mods[@]}"
do
   module load $i
   rm a.out
   mpicc hello_c.c
   salloc -N 2 srun --mpi=pmi2 ./a.out > test.err 
   mpi_errors test.err $i
   module unload $i
done
