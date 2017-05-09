#!/bin/bash

rm -r vasp.3_5_COonNi111_rel
cp -r 3_5_COonNi111_rel.orig vasp.3_5_COonNi111_rel

cat << EOF2 > check_vasp.sh
#!/bin/bash
#SBATCH -n 1
#SBATCH -o ../vasp.result.out
if ! grep "reached required accuracy - stopping structural energy minimisation" vasp-test.out; then
echo "FAILED: vasp did not finish"
fi
grep real vasp-test.out 
EOF2

cat <<\EOF > vasp.sh
#!/bin/bash
#SBATCH -N 2
#SBATCH --ntasks-per-node=2
#SBATCH -o vasp-test.out
#SBATCH -e vasp-test.out
#SBATCH -D vasp.3_5_COonNi111_rel

module load vasp/5.4.1

sbatch --dependency=afterok:$SLURM_JOB_ID ../check_vasp.sh

time srun -n 4 vasp
EOF
sbatch vasp.sh
myq



