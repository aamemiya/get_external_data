#!/bin/bash -l

source ~/.bashrc

wkdir="$( cd "$( dirname "$0" )" && pwd )"
datadir=$wkdir/..


cd ${wkdir}
now=`date -u +'%Y-%m-%d %H:%M:%S'`


#GET_TIME=`date -u -d "+ 6 hour ${PREVIOUS_TIME}" +'%Y-%m-%d %H'`
#GET_TIME="2021-11-20 00"

GET_TIME="$1"

YYYY=`date -u -d "$GET_TIME" +'%Y'`
MM=`date -u -d "$GET_TIME" +'%m'`
DD=`date -u -d "$GET_TIME" +'%d'`
HH=`date -u -d "$GET_TIME" +'%H'`
YYYYMMDDHH="$YYYY$MM$DD$HH"

echo "$now [TRY ] $YYYYMMDDHH" >> ${wkdir}/makeobs.log

mkdir -p ${wkdir}/$YYYYMMDDHH
cd ${wkdir}/$YYYYMMDDHH


  now=`date -u +'%Y-%m-%d %H:%M:%S'`
  echo "$now [CONV] $YYYYMMDDHH: dec_prepbufr" >> ${wkdir}/makeobs.log
  bash $wkdir/run/dec_prepbufr/convert.sh "${YYYY}-${MM}-${DD} ${HH}" "$wkdir/${YYYYMMDDHH}" "$datadir/ncepobs_gdas_letkf/${YYYYMMDDHH}" \
   > ${wkdir}/convert_dec_prepbufr.log 2>&1


  now=`date -u +'%Y-%m-%d %H:%M:%S'`
  echo "$now [DONE] $YYYYMMDDHH" >> ${wkdir}/makeobs.log

