#!/bin/bash

# Aim: check if module directories have a CCVREADME or a CCV_README

s=$(basename -- "$0")
resultsfile="results."${s%.*}

date > $resultsfile

for mod in $(ls /gpfs/runtime/opt/)
do

   if [[  -z `find /gpfs/runtime/opt/$mod -maxdepth 2 -name CCVREADME` ]] && [[  -z `find /gpfs/runtime/opt/$mod -maxdepth 2 -name CCV_README` ]]; then
     echo -n "FAILED: " $mod >> $resultsfile
     echo -n  "  installed by : " >> $resultsfile
     ls -ld /gpfs/runtime/opt/$mod | awk '{print $3}' >> $resultsfile
   fi
   
done
