#!/bin/bash -x

#AIM: compile and run npb mpi benchmarks and record the time

TESTDIR=$PWD
NPBDIR=/users/hkershaw/scratch/centos7/acceptance_tests/npb/NPB3.3.1/NPB3.3-MPI
#MPIMOD=mpi/mvapich2-2.3a_intel 
#MPIMOD=mpi/mvapich2-2.3a_gcc
MPIMOD=mpi/mvapich2-2.3a_pgi

# Old mpi version hangs
#MPIMOD=mpi/debug_mvapich2-2.0rc1_intel
#MPIMOD=mpi/mvapich2-2.2_intel
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
##SBATCH --mem 50GB
#SBATCH -D $NPBDIR
#SBATCH -t 1:00:00

module load $MPIMOD

#export MV2_USE_SHMEM_COLL=0
#export MV2_USE_BLOCKING=1
#export MV2_SMP_USE_CMA=0

env | grep MV2

#srun -n 64 bin/bt.D.64
srun --mpi=pmi2 -n 64 bin/bt.D.64

EOF

sbatch npb.sh
myq

