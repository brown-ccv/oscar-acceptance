#!/bin/bash

# Aim:
# submit array job with 1000 jobs

cat << EOFF > pi.f90
program pi

implicit none

integer, parameter :: DARTS = 50000, ROUNDS = 10, MASTER = 0

real(8) :: pi_est
real(8) :: homepi, avepi, pirecv, pisum
integer :: rank
integer :: i, n, clock
integer, allocatable :: seed(:)

! we set it to zero in the sequential run
rank = 0

CALL SYSTEM_CLOCK(COUNT=clock)

! initialize the random number generator
! we make sure the seed is different for each task
call random_seed()
call random_seed(size = n)
allocate(seed(n))
!seed = 12 + rank*11
seed = clock + rank*11
call random_seed(put=seed(1:n))
deallocate(seed)

avepi = 0
do i = 0, ROUNDS-1
   pi_est = dboard(DARTS)

   ! calculate the average value of pi over all iterations
   avepi = ((avepi*i) + pi_est)/(i + 1)

   print *, "After ", DARTS*(i+1), " throws, average value of pi =", avepi
end do

contains

   real(8) function dboard(darts)

      integer, intent(in) :: darts

      real(8) :: x_coord, y_coord
      integer :: score, n

      score = 0
      do n = 1, darts
         call random_number(x_coord)
         call random_number(y_coord)

         if ((x_coord**2 + y_coord**2) <= 1.0d0) then
            score = score + 1
         end if
      end do
      dboard = 4.0d0*score/darts

   end function

end program
EOFF


cat << \EOF > array.sh
#!/bin/bash

#SBATCH -J array
#SBATCH -n 1 
#SBATCH --array=1-1000
#SBATCH -D arrays

#SBATCH -e %A-%a.err
#SBATCH -o %A-%a.out

# This gives 1000 checks
#sbatch --dependency=afterok:$SLURM_JOB_ID ../check_array.sh

./pi

EOF

# script to check results
cat << \EOFC > check_array.sh
#!/bin/bash

#SBATCH -n 1
#SBATCH -o array.result.out

date
for f in arrays/*.err; do
  if [ $(wc -l < $f) -ne 0 ]
  then
    echo "FAILED: errors"
  fi 
done

EOFC

# prepare directory
rm -r arrays
mkdir arrays
# compile code
gfortran pi.f90 -o pi
mv pi arrays/

job=$(sbatch  array.sh)
echo "job id " ${job##* }
sbatch --dependency=afterok:${job##* } check_array.sh
myq
