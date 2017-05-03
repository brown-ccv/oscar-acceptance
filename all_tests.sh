#!/bin/bash
# Run all acceptance tests

./file_read_write.sh
./old_queues.sh
./slurm_querries.sh
./load_unload_modules.sh
./run_mpi.sh
./submit_queues.sh


echo "******************"
echo "** test results **"
echo "******************"


grep FAILED *.out
