#!/bin/bash -l

wkdir="$( cd "$( dirname "$0" )" && pwd )"

datadir=$wkdir/..  ### EDIT ME

cd ${wkdir}
now=`date -u +'%Y-%m-%d %H:%M:%S'`

if [ -e "${wkdir}/running_plot" ]; then
  echo "$now [PREV]" >> ${wkdir}/plot_past.log
  exit
else
  touch ${wkdir}/running_plot
fi

GET_TIME_START="2025-01-22 21:00:00"
GET_TIME_END="2025-02-05 15:00:00"
GET_TIME=$GET_TIME_START

while [ $(date -ud "$GET_TIME" +%s) -le $(date -ud "$GET_TIME_END" +%s) ] ;do 

YYYY=`date -u -d "$GET_TIME" +'%Y'`
MM=`date -u -d "$GET_TIME" +'%m'`
DD=`date -u -d "$GET_TIME" +'%d'`
HH=`date -u -d "$GET_TIME" +'%H'`
YYYYMMDDHH="$YYYY$MM$DD$HH"
YYYYMMDD=${YYYYMMDDHH:0:8}

echo "$now [TRY ] $YYYYMMDDHH" >> ${wkdir}/plot_past.log

mkdir -p ${datadir}/msm/$YYYYMMDDHH
cd ${datadir}/msm/$YYYYMMDDHH

cfiles=MSM${YYYYMMDDHH}S.nc
cfilep=MSM${YYYYMMDDHH}P.nc

bash $wkdir/run/grads/convert.sh "$datadir/msm/${YYYYMMDDHH}"  &> plot_past.log 

allget=1

### hourly plot
t=0
while ((t <= 33)); do ### extended ?
tf=`printf '%03d' $t`
TIME_fcst=`date -ud "${t} hour $YYYY-$MM-$DD $HH" +'%Y-%m-%d %H:%M:%S'`
YYYYMMDDHHMMSS_fcst=`date -ud "$TIME_fcst" +'%Y%m%d%H%M%S'`
      now=`date -u +'%Y-%m-%d %H:%M:%S'`
      echo "$now [PLOT] $YYYYMMDDHH - Plot (background job)" >> ${wkdir}/plot_past.log
      bash $wkdir/run/plot/plot.sh "$TIME_fcst" "$GET_TIME" $((t+1)) "$datadir/msm/${YYYYMMDDHH}" \
       >> ${wkdir}/convert_plot.log 2>&1
      bash $wkdir/run/plot/plot_d3.sh "$TIME_fcst" "$GET_TIME" $((t+1)) "$datadir/msm/${YYYYMMDDHH}" \
       >> ${wkdir}/convert_plot_d3.log 2>&1
t=$((t+1))
done

GET_TIME=$(date -ud "3 hours $GET_TIME" +"%F %T")
done # GET_TIME 


if ((allget == 1)); then
  now=`date -u +'%Y-%m-%d %H:%M:%S'`
  echo "$now [DONE] $YYYYMMDDHH" >> ${wkdir}/plot_past.log
fi

rm -f ${wkdir}/running_plot
