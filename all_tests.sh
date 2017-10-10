#!/bin/bash
# Run acceptance tests

#-----------------------------------------------------------------
#                       ---- Globals ---
#-----------------------------------------------------------------
# File names
testsran="list_of_tests_ran" # file listing which tests ran
count=0              # count how many tests ran
fails=all_failed.results
#-----------------
#-----------------------------------------------------------------

#-----------------------------------------------------------------
#                       --- Functions ---
#-----------------------------------------------------------------
# -- Initialize test enviroment --
setup () {
  echo "removing old test files"
  for f in *.out; do
     [ -e "$f" ] || continue
     echo $f
     rm $f
  done
  [ -e results.out ] && rm results.test
date > $testsran
}
# -------------------------------

#-- End test environment ----
tear_down() {
cat <<EOF > README
Tests results for Oscar.  
EOF
  grep FAILED results.test* | tee $fails
  tarfile=results."$(date +%F-%H%M%S)".tgz
  tar czf $tarfile results.test* $fails $testsran README
  rm results.test*
  rm README
  rm all_failed.results
  rm $testsran
}
#-----------------------------
#-----------------------------------------------------------------


#-----------------------------------------------------------------
#                     --- Test script ---
#-----------------------------------------------------------------
#-- Parse in
# check there is an argumment
if [ $# -lt 1 ]; then
  echo -e "Usage: $(basename $0) [test names] \n To run all tests:  ./all_tests.sh all"
  echo -e " test scrips must start with 'test_*' and print 'FAILED' to 'results.test*'"
  echo    " Output is in tar file results.'date-time'.tgz"
  exit 1
fi

# parse arguements
if [ $1 == "all" ]; then
  run_all=1;
else
  run_all=0;
  declare -a tests
  for t in "$@"; do  # check the arguements are actually test scripts
     if [[ -e $t && $t == test_* ]]; then
        tests+=($t)
     else
        echo $t "is not a test script"
     fi
  done  
fi

setup  # remove any existing test results

#------------------------
# Start of running tests
#------------------------
if [ $run_all == 1 ]; then # run all tests
   for t in test_*; do
     echo $t >> $testsran
     ./$t
     count=$((count+1))
   done
else                      # run given tests
   for t in "${tests[@]}";
   do 
      echo $t >> $testsran
      ./$t
      count=$((count+1))
   done
fi

if [ $count == 0 ]; then
   echo "0 tests ran. Check your input"
else
   tear_down
fi

