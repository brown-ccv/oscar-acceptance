Aim: semi-automated acceptance tests for new systems and downtimes

# For users: #

all_tests.sh is the master script.  This takes care of setting up and tearing down
the test environment. The individual tests are scripts named: test_<testname>.sh

To run any or all of the tests, use:

`all_tests.sh [test names]` 

Output is in tar file results.'date-time'.tgz

### Example usage ###
Run all tests:

`./all_tests.sh all`

Run test_cpu_affinity.sh and test_file_read_write.sh:

`all_tests.sh test_cpu_affinity.sh test_file_read_write.sh`

The results are written to results.date-time.tgz

# For develpers #
## Adding a new test ##

Each test script must:

- start with 'test_*'
- print any failures as 'FAILED' to 'results.test*'
- not run as a background process.
- have the 'Aim' in a comment in the test script
- Must be pass/fail
- be executable (./test_*). Note, currently all tests are written in bash, but there is no requirment for this

The granularity of the tests is intended to be like a unit test
Some of these tests stretch that definition e.g. test_run_mpi.sh 
tests all the mpi modules. The tests were built to test the upgrade of the
CCV machine to RedHat 7.


The flow of all_tests.sh is as follows:

1. parse arguements
2. setup
3. run tests
4. tear down


all_tests.sh setup:

 - removes *.out
 - removed *.test
 - adds the date to the list_of_tests_ran file

all_tests.sh tear_down:

 - greps for FAILED in results.test*  Outputs this to the screen and all_failed.results
 - creates a tarfile of the results: results.date-time.tgz
 - adds a README to the tar file (see inside all_tests.sh for the contents)
 - adds results.test*  list_of_all_test_ran all_failed.results to tar file
 - removes results files


# Other files in this repository #

There are VASP, molpro, LAMMPS, nwchem and NPB test files in this respository.  These
have not been added to the all_tests.sh framework yet.

To do list: 

*overload nodes*

*Programs*

- Vasp
- LAMMPS
- Molpro
- NPB

*test harness*

- be able to pass a set of tests, e.g. application tests, slurm tests.
- set a timeout (failing slurm commands hang the test harness)

*VNC*

*CIFS*
