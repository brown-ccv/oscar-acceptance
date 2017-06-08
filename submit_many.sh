#!/bin/bash

# Aim:
# submit many jobs with 1000 jobs

cat << EOFF > pi-many.f90
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


cat << \EOF > many.sh
#!/bin/bash

#SBATCH -J many 
#SBATCH -n 1 
#SBATCH -D many 

./pi-many

EOF

# prepare directory
rm -r many 
mkdir many
# compile code
gfortran pi-many.f90 -o pi-many
mv pi-many many/

for (( j=1; j<=10000; j++ ))
do
  sbatch many.sh
  #job=$(sbatch  many.sh)
  #echo "job id " ${job##* }
done
myq
