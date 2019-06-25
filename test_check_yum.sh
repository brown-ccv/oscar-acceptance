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
computenodes=(  \
"node404"        \
"node409"        \
"node410"        \
"node411"        \
"node412"        \
"node413"        \
"node414"        \
"node415"        \
"node416"        \
"node417"        \
"node418"        \
"node419"        \
"node420"        \
"node421"        \
"node422"        \
"node423"        \
"node424"        \
"node425"        \
"node433"        \
"node434"        \
"node435"        \
"node436"        \
"node437"        \
"node438"        \
"node439"        \
"node440"        \
"node441"        \
"node442"        \
"node443"        \
"node444"        \
"node445"        \
"node446"        \
"node447"        \
"node448"        \
"node449"        \
"node450"        \
"node451"        \
"node452"        \
"node453"        \
"node454"        \
"node455"        \
"node456"        \
"node457"        \
"node458"        \
"node459"        \
"node460"        \
"node461"        \
"node462"        \
"node463"        \
"node475"        \
"node476"        \
"node509"        \
"node510"        \
"node511"        \
"node512"        \
"node513"        \
"node514"        \
"node515"        \
"node516"        \
"node517"        \
"node518"        \
"node519"        \
"node520"        \
"node521"        \
"node522"        \
"node527"        \
"node528"        \
"node529"        \
"node531"        \
"node532"        \
"node533"        \
"node535"        \
"node537"        \
"node548"        \
"node549"        \
"node550"        \
"node551"        \
"node552"        \
"node553"        \
"node554"        \
"node555"        \
"node556"        \
"node557"        \
"node558"        \
"node559"        \
"node560"        \
"node561"        \
"node562"        \
"node563"        \
"node564"        \
"node565"        \
"node566"        \
"node567"        \
"node568"        \
"node569"        \
"node570"        \
"node571"        \
"node580"        \
"node581"        \
"node582"        \
"node601"        \
"node602"        \
"node603"        \
"node604"        \
"node605"        \
"node606"        \
"node607"        \
"node608"        \
"node609"        \
"node610"        \
"node611"        \
"node612"        \
"node613"        \
"node614"        \
"node615"        \
"node616"        \
"node617"        \
"node618"        \
"node619"        \
"node620"        \
"node621"        \
"node622"        \
"node623"        \
"node624"        \
"node625"        \
"node626"        \
"node627"        \
"node628"        \
"node629"        \
"node630"        \
"node631"        \
"node632"        \
"node633"        \
"node634"        \
"node635"        \
"node636"        \
"node637"        \
"node638"        \
"node639"        \
"node640"        \
"node641"        \
"node642"        \
"node643"        \
"node644"        \
"node647"        \
"node648"        \
"node649"        \
"node650"        \
"node651"        \
"node652"        \
"node653"        \
"node654"        \
"node655"        \
"node656"        \
"node657"        \
"node658"        \
"node659"        \
"node660"        \
"node801"        \
"node802"        \
"node803"        \
"node804"        \
"node805"        \
"node806"        \
"node807"        \
"node808"        \
"node809"        \
"node810"        \
"node811"        \
"node812"        \
"node813"        \
"node814"        \
"node815"        \
"node816"        \
"node817"        \
"node818"        \
"node819"        \
"node820"        \
"node821"        \
"node822"        \
"node823"        \
"node824"        \
"node825"        \
"node826"        \
"node827"        \
"node828"        \
"node829"        \
"node830"        \
"node831"        \
"node832"        \
"node833"        \
"node834"        \
"node835"        \
"node836"        \
"node837"        \
"node838"        \
"node840"        \
"node844"        \
"node847"        \
"node848"        \
"node849"        \
"node850"        \
"node851"        \
"node852"        \
"node853"        \
"node854"        \
"node901"        \
"node902"        \
"node903"        \
"node904"        \
"node905"        \
"node906"        \
"node907"        \
"node908"        \
"node909"        \
"node910"        \
"node911"        \
"node912"        \
"node913"        \
"node914"        \
"node915"        \
"node916"        \
"node917"        \
"node918"        \
"node919"        \
"node920"        \
"node921"        \
"node922"        \
"node923"        \
"node924"        \
"node925"        \
"node926"        \
"node927"        \
"node928"        \
"node929"        \
"node930"        \
"node931"        \
"node932"        \
"node933"        \
"node934"        \
"node935"        \
"node936"        \
"node937"        \
"node938"        \
"node939"        \
"node940"        \
"node941"        \
"node944"        \
"node945"        \
"node946"        \
"node947"        \
"node948"        \
"node949"        \
"node950"        \
"node951"        \
"node952"        \
"node953"        \
"node954"        \
"node955"        \
"node956"        \
"node957"        \
"node958"        \
"node959"        \
"node960"        \
"node961"        \
"node962"        \
"node963"        \
"node964"        \
"node965"        \
"node966"        \
"node967"        \
"node968"        \
"node969"        \
"node970"        \
"node971"        \
"node972"        \
"node973"        \
"node974"        \
"node975"        \
"node976"        \
"node1001"       \
"node1002"       \
"node1003"       \
"node1004"       \
"node1005"       \
"node1006"       \
"node1007"       \
"node1008"       \
"node1009"       \
"node1010"       \
"node1011"       \
"node1012"       \
"node1013"       \
"node1014"       \
"node1015"       \
"node1016"       \
"node1017"       \
"node1018"       \
"node1019"       \
"node1020"       \
"node1021"       \
"node1022"       \
"node1023"       \
"node1024"       \
"node1025"       \
"node1026"       \
"node1027"       \
"node1028"       \
"node1029"       \
"node1030"       \
"node1031"       \
"node1032"       \
"node1033"       \
"node1034"       \
"node1035"       \
"node1036"       \
"node1037"       \
"node1038"       \
"node1039"       \
"node1040"       \
"node1041"       \
"node1042"       \
"node1043"       \
"node1044"       \
"node1045"       \
"node1046"       \
"node1047"       \
"node1048"       \
"node1049"       \
"node1050"       \
"node1051"       \
"node1052"       \
"node1053"       \
"node1054"       \
"node1055"       \
"node1056"       \
"node1057"       \
"node1058"       \
"node1059"       \
"node1061"       \
"node1062"       \
"node1063"       \
"node1064"       \
"node1101"       \
"node1102"       \
"node1103"       \
"node1104"       \
"node1105"       \
"node1106"       \
"node1107"       \
"node1108"       \
"node1109"       \
"node1110"       \
"node1111"       \
"node1112"       \
"node1113"       \
"node1114"       \
"node1115"       \
"node1116"       \
"node1117"       \
"node1118"       \
"node1119"       \
"node1120"       \
"node1121"       \
"node1122"       \
"node1123"       \
"node1124"       \
"node1125"       \
"node1126"       \
"node1127"       \
"node1128"       \
"node1129"       \
"node1130"       \
"node1131"       \
"node1132"       \
"node1133"       \
"node1134"       \
"node1135"       \
"node1136"       \
"node1137"       \
"node1138"       \
"node1139"       \
"node1140"       \
"node1141"       \
"node1142"       \
"node1143"       \
"node1144"       \
"node1145"       \
"node1146"       \
"node1147"       \
"node1148"       \
"node1149"       \
"node1150"       \
"node1151"       \
"node1152"       \
"node1153"       \
"node1154"       \
"node1155"       \
"node1156"       \
"node1157"       \
"node1158"       \
"node1159"       \
"node1160"       \
"node1161"       \
"node1162"       \
"node1163"       \
"node1164"       \
"node1301"       \
"node1302"       \
"node1303"       \
"node1304"       \
"node1305"       \
"node1306"       \
"node1307"       \
"node1308"       \
"node1309"       \
"node1310"       \
"node1311"       \
"node1312"       \
"node1313"       \
"node1314"       \
"node1315"       \
"node1317"       \
"node1318"       \
"node1319"       \
"node1320"       \
"node1321"       \
"node1322"       \
"node1323"       \
"node1324"       \
"node426"        \
"node427"        \
"node428"        \
"node429"        \
"node430"        \
"node431"        \
"node432"        \
)

# gpunodes
gpunodes=(       \
"gpu706"         \
"gpu707"         \
"gpu709"         \
"gpu710"         \
"gpu711"         \
"gpu712"         \
"gpu714"         \
"gpu717"         \
"gpu718"         \
"gpu717"         \
"gpu718"         \
"gpu1201"        \
"gpu1202"        \
"gpu1203"        \
"gpu1204"        \
"gpu1206"        \
"gpu1207"        \
"gpu1208"        \
"gpu1209"        \
"gpu1210"        \
"gpu1211"        \
"gpu1212"        \
"gpu1213"        \
"gpu1214"        \
"gpu1215"        \
"gpu1216"        \
"gpu1217"        \
"gpu1218"        \
"gpu1206"        \
"gpu702"         \
)




## vncnodes I don't think node408 is supposed to be vnc
#vncnodes=("node408" "cave020" "gpu716")

count=0
nodeloop "${loginnodes[@]}"
count=0
nodeloop "${computenodes[@]}"
count=0
nodeloop "${gpunodes[@]}"
#count=0
#nodeloop "${vncnodes[@]}"

