#!/bin/bash

# loads and unloads each module in the modulefiles directory
# /gpfs/runtime/modulefiles
# writes success/failure to resultsfile=module.results.out

resultsfile=module.results.out

is_success() {
  #echo $1
  if [ $1 -ne 0 ]; then
     echo "FAILED: " $2 >> $resultsfile
  else
     #echo '.' >> $resultsfile 
     echo 'test passed: ' $2 >> $resultsfile
  fi  
}

date > $resultsfile 
for mod in /gpfs/runtime/modulefiles/* ; do
   app=$(basename $mod) 
   echo "$app"
   module load $app
   is_success $? "load $app"
   module unload $app  
   is_success $? "unload $app"
    
done
