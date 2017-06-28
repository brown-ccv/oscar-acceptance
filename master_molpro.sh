#!/bin/bash

echo "Starting master"

rm -r molpro
mkdir molpro
cp tlbr_mp2_dft_so.test molpro

cat << EOF2 > check_molpro.sh
#!/bin/bash
#SBATCH -n 1
#SBATCH -o ../molpro.result.out
grep real molpro-test.out

if grep ERRORS test.log; then
echo "FAILED: errors in molpro run"
fi 

EOF2


cat <<\EOF > molpro.sh
#!/bin/bash

#SBATCH -N 2
#SBATCH --ntasks-per-node=4
#SBATCH -o molpro-test.out
#SBATCH -e molpro-test.out
#SBATCH -D molpro
#SBATCH -C 7.3

module load Molpro/2015_gcc
module load mpi/mvapich2-2.0rc1_gcc

sbatch --dependency=afterok:$SLURM_JOB_ID ../check_molpro.sh

time molpro -n 8 tlbr_mp2_dft_so.test
EOF

sbatch molpro.sh
myq
