#!/bin/bash

# Aim: test if old qos are present in the slurm database
# Fail if they are

s=$(basename -- "$0")
resultsfile="results."${s%.*}

if [[ $(sacctmgr list assoc | grep -m 1 ivy) ]]; then
  echo FAILED ivy in assoc > $resultsfile
fi
