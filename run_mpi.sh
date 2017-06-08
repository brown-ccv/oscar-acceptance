#!/bin/bash

# Aim: compile and run a hello world for each of the mpi modules
# If anything is written to stderr this counts as a failed test

# mpi/mvapich2-2.0rc1_gcc    mpi/openmpi_2.0.1_gcc      
# mpi/mvapich2-2.0rc1_intel  mpi/openmpi_2.0.1_intel    
# mpi/mvapich2-2.0rc1_pgi    mpi/openmpi_2.0.1_pgi   

module load pgi

resultsfile=mpi.results.out

mpi_errors() {
   if [ `grep -v salloc $1 | wc -l` -gt 1 ]; then
      echo "FAILED " $2 | tee -a $resultsfile
   fi
}

date > $resultsfile 

# Slurm commands - pgi has a bug that affects openmpi
mods=("mpi/mvapich2-2.0rc1_gcc" "mpi/mvapich2-2.0rc1_intel" "mpi/mvapich2-2.0rc1_pgi" \
      "mpi/openmpi_2.0.1_gcc" "mpi/openmpi_2.0.1_intel") # "mpi/openmpi_2.0.1_pgi")
#mods=("mpi/openmpi_2.0.1_intel")
for i in "${mods[@]}"
do
   module load $i
   rm a.out
   mpicc hello_c.c
   #salloc -N 2  srun ./a.out 2>> $resultsfile
   salloc -N 2  srun ./a.out 2>test.err 
   mpi_errors test.err $i
   module unload $i
done






