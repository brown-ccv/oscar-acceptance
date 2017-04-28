#!/bin/bash

resultsfile=old.queues.results.out

queue_errors() {
   if ! grep "invalid partition specified" "$1"
   then
      echo "FAILED " $2 | tee -a $resultsfile
   fi
}

date > $resultsfile

old_partitions=("DEFAULT" \
"test" \
"maint-batch"\
"default-batch" \
"jpober-test" \
"tiny-batch" \
"small-batch" \
"sandy-batch" \
"ivy-batch" \
"sandy-test" \
"sandy-mem" \
"bibs-smp")

for i in "${old_partitions[@]}"
do
   salloc -n 1 -p $i srun echo "hello" 2> test.err
   queue_errors test.err $i
done


