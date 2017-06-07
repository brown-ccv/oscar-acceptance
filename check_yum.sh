#!/bin/bash 

# Aim: compare list of yum installed packages

# login003 vs login004
# gpu001 vs gpu002
# node401-node424 [node408] is vnc

testdir=$(pwd)

node=("login003" "login004")

count=0

for n in "${node[@]}"
do

   ssh -T $n << EOF
   echo $HOSTNAME
   cd $testdir
   module unload python
   yum list installed > $n.out
   exit
EOF

   # wc
   lines=`wc -l < $n.out`
   if ((count == 0)); then  #first time 
     echo $lines
     count=$lines
   else # already got a line count
      if((count != $lines)); then
         echo "ERROR: yum list installed different"
      fi
   fi 




done
