#!/bin/bash
# Run all acceptance tests

rm *.out 

./test_file_read_write.sh
./test_old_queues.sh
./test_slurm_querries.sh
./test_load_unload_modules.sh
./test_run_mpi.sh
./test_submit_queues.sh
./test_module_defaults.sh
./test_check_yum.sh

echo "******************"
echo "** test results **"
echo "******************"


grep FAILED results.test* | tee all_failed.results
