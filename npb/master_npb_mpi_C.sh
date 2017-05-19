#!/bin/bash -x

#AIM: compile and run npb mpi benchmarks and record the time

TESTDIR=$PWD
NPBDIR=/users/hkershaw/scratch/centos7/acceptance_tests/npb/NPB3.3.1/NPB3.3-MPI
MPIMOD=mpi/mvapich2-2.0rc1_intel

cd $NPBDIR
module load $MPIMOD

make clean
make bt NPROCS=64 CLASS=C

cd $TESTDIR 

cat <<EOF > npb.sh
#!/bin/bash

#SBATCH -N 4-4 
#SBATCH --ntasks-per-node=16
#SBATCH -o $TESTDIR/npb-test.out
#SBATCH -e $TESTDIR/npb-test.out
#SBATCH -D $NPBDIR

module load $MPIMOD

srun -n 64 bin/bt.C.64

EOF

sbatch npb.sh
myq

