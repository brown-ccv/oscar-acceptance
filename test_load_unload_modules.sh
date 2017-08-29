#!/bin/bash

# loads and unloads each module in the modulefiles directory
# /gpfs/runtime/modulefiles
# writes success/failure to resultsfile=module.results.out
# Note module load returns 0 (succss) when a module does not load
# so you have to check the message

resultsfile=module.results.out

is_success() {
  #echo $1
  if [[ "$1" =~ "unknown" ]]; then
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
   #module load $app 
   MESSAGE="$(module load $app 2>&1)" 
   is_success "$MESSAGE" "load $app"
   #module unload $app  
   MESSAGE="$(module unload $app 2>&1)" 
   is_success "$MESSAGE" "unload $app"
    
done
