#!/bin/bash
# Aim: test that you can read and write in home, scratch, data

s=$(basename -- "$0")
resultsfile="results."${s%.*}

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

# File ls 
locations=(~ ~/scratch ~/data)
for i in "${locations[@]}"
do
   ls $i  
   is_success $? "ls $i"
done


# File writes, reads: touch, echo, cat
locations=(~ ~/scratch ~/data)
for i in "${locations[@]}"
do
   touch $i/testme  
   is_success $? "touch $i"
   echo "Welcome to the Jungle" > $i/testme
   is_success $? "write $i"
   cat $i/testme
   is_success $? "read $i"
done
