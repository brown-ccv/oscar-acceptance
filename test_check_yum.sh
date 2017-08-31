#!/bin/bash 

# Aim: compare list of yum installed packages

# See #Tests for which nodes are compared against each other
# login003 vs login004
# gpu001 vs gpu002
# node401-node424 [node408] is vnc

#global:
count=0
rm -r yumtests
mkdir yumtests
cd yumtests
testdir=$(pwd)
s=$(basename -- "$0")
resultsfile="../results."${s%.*}

# function to check if counts are different
yumdiff () {

   lines=`wc -l < $1`
   if ((count == 0)); then  #first time 
     echo $lines $1
     count=$lines
   else # already got a line count
      if((count != $lines)); then
         echo "FAILED: yum list installed different" $1 >> $resultsfile
      fi  
   fi  
}

# function to loop through 'identical' nodes
nodeloop () {

node=("$@")

for n in "${node[@]}"
do

   ssh -T $n << EOF
   cd $testdir
   module unload python
   #yum list installed > $n.out
   rpm -qa > $n.out
   exit
EOF

   # wc
   yumdiff $n.out

done
}

# Tests:
date > $resultsfile

# login nodes
loginnodes=("login003" "login004")

# compute nodes
computenodes=("node401" "node402" "node403" "node404" "node405" "node406" "node407" \
              "node475" "node476" "smp015")

# gpunodes
gpunodes=("gpu001" "gpu002")

# vncnodes I don't think node408 is supposed to be vnc
vncnodes=("node408" "cave020" "gpu716")

count=0
nodeloop "${loginnodes[@]}"
count=0
nodeloop "${computenodes[@]}"
count=0
nodeloop "${gpunodes[@]}"
count=0
nodeloop "${vncnodes[@]}"

