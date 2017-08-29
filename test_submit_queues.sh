#!/bin/bash

# Aim: test that you can submit to each of the queues


resultsfile=queues.results.out

queue_errors() {
   if grep error "$1" 
   then
      echo "FAILED " $2 | tee -a $resultsfile
   fi
}


date > $resultsfile

queues=("batch" "debug" "gpu" "bibs-gpu" "vnc")
#queues=("debug")
for i in "${queues[@]}"
do
   salloc -n 1 -p $i srun echo "hello" 2> test.err
   queue_errors test.err $i
done

