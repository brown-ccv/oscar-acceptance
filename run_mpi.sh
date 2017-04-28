#!/bin/bash

# Aim: compile and run a hello world for each of the mpi modules

# mpi/mvapich2-2.0rc1_gcc    mpi/openmpi_2.0.1_gcc      
# mpi/mvapich2-2.0rc1_intel  mpi/openmpi_2.0.1_intel    
# mpi/mvapich2-2.0rc1_pgi    mpi/openmpi_2.0.1_pgi   

resultsfile=mpi.results.out

is_success() {
  #echo $1
  if [ $1 -ne 0 ]; then
     echo "test failed: " $2 >> $resultsfile
  else
     #echo '.' >> $resultsfile 
     echo 'test passed: ' $2 >> $resultsfile
  fi  
}

date > $resultsfile 

# Slurm commands
mods=("mpi/mvapich2-2.0rc1_gcc" "mpi/mvapich2-2.0rc1_intel" "mpi/mvapich2-2.0rc1_pgi" \
      "mpi/openmpi_2.0.1_gcc" "mpi/openmpi_2.0.1_intel" "mpi/openmpi_2.0.1_pgi")
#mods=("mpi/mvapich2-2.0rc1_gcc")
for i in "${mods[@]}"
do
   module load $i  
   mpicc hello_c.c
   salloc -N 2  srun ./a.out 2>> $resultsfile
   module unload $i
done


if [ `grep -v salloc mpi.results.out | wc -l` -gt 1 ]; then
   echo " ***  FAILED **** check output"
fi





