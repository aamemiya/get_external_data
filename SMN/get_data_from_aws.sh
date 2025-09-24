#!/bin/bash

myname=$(realpath $0)
wkdir=$(dirname $myname)

TIME=$1
DRY_RUN=${2:-0}

cy=${TIME:0:4}
cmm=${TIME:4:2}
cdd=${TIME:6:2}
chh=${TIME:8:2}

hours=72

mkdir -p $wkdir/data/$TIME
cd $wkdir/data/$TIME

if [ $DRY_RUN == 1 ];then
  cfh=000
  res=$(wget -q --spider https://smn-ar-wrf.s3.amazonaws.com/DATA/WRF/DET/${cy}/${cmm}/${cdd}/${chh}/WRFDETAR_01H_${cy}${cmm}${cdd}_${chh}_${cfh}.nc)
#  echo "dry run return code:"$res
#  exit $res
else
  thread=8
  count=0
  for cfh in $(seq -f %03g 0 $hours) ;do 
    count=$((count+1))
    wget -nc https://smn-ar-wrf.s3.amazonaws.com/DATA/WRF/DET/${cy}/${cmm}/${cdd}/${chh}/WRFDETAR_01H_${cy}${cmm}${cdd}_${chh}_${cfh}.nc & 
    if [ ${count} == 8 ] ;then
      wait
      count=0 
    fi
  done
  wait
fi
