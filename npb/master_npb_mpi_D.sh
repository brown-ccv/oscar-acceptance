#!/bin/bash -x

#AIM: compile and run npb mpi benchmarks and record the time

TESTDIR=$PWD
NPBDIR=/users/hkershaw/scratch/centos7/acceptance_tests/npb/NPB3.3.1/NPB3.3-MPI
MPIMOD=mpi/mvapich2-2.0rc1_intel
#MPIMOD=mpi/mvapich2-2.0rc1_gcc
#MPIMOD=mpi/openmpi_2.0.1_intel  

cd $NPBDIR
module load $MPIMOD

make clean
make bt NPROCS=64 CLASS=D

cd $TESTDIR 

cat <<EOF > npb.sh
#!/bin/bash

#SBATCH -N 4-4 
#SBATCH --ntasks-per-node=16
#SBATCH -o $TESTDIR/npb-test-D.%j.out
#SBATCH -e $TESTDIR/npb-test-D.%j.out
#SBATCH -D $NPBDIR
#SBATCH -t 1:00:00

module load $MPIMOD

#export MV2_USE_SHMEM_COLL=0
export MV2_USE_BLOCKING=1

srun -n 64 bin/bt.D.64

EOF

sbatch npb.sh
myq

