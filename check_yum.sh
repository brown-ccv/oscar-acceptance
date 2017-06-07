#!/bin/bash 

# Aim: compare list of yum installed packages

# login003 vs login004
# gpu001 vs gpu002
# node401-node424 [node408] is vnc

#global:
count=0
testdir=$(pwd)

# function to check if counts are different
yumdiff () {

   lines=`wc -l < $1`
   if ((count == 0)); then  #first time 
     echo $lines
     count=$lines
   else # already got a line count
      if((count != $lines)); then
         echo "ERROR: yum list installed different" $1
      fi  
   fi  
}

# function to loop through 'identical' nodes
nodeloop () {
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
   yumdiff $n.out

done
}

# login nodes
loginnodes=("login003" "login004")

# compute nodes
computenodes=("node401" "node402" "node403" "node404" "node405" "node406" "node407" "node409" \
              "node410" "node411" "node412" "node413" "node414" "node415" "node416" "node417" \
              "node418" "node419" "node420" "node421" "node422" "node423" "node424")

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
   yumdiff $n.out

done

