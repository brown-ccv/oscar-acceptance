#!/bin/bash

s=$(basename -- "$0")
resultsfile="results."${s%.*}
temporaryfile=test.err

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
   salloc -n 1 -p $i srun echo "hello" 2> $temporaryfile
   queue_errors $temporaryfile $i
done

#cleanup
rm $temporaryfile
