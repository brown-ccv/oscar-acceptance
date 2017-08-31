#!/bin/bash

# Aim: check if modulefiles have a default

s=$(basename -- "$0")
resultsfile="results."${s%.*}

date > $resultsfile

for mod in $(grep -rn -L default /gpfs/runtime/modulefiles;)
do
  app=$(basename $mod)
  if [[ "$app" != ".modules" ]]; then
      echo "FAILED: " $app >> $resultsfile
  fi
done

