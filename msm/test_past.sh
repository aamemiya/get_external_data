#!/bin/bash -l

wkdir="$( cd "$( dirname "$0" )" && pwd )"

MSMSRCDIR=http://database.rish.kyoto-u.ac.jp/arch/jmadata/data/gpv/latest
datadir=$wkdir/..  ### EDIT ME

cd ${wkdir}
now=`date -u +'%Y-%m-%d %H:%M:%S'`

GET_TIME="$1"
YYYY=`date -u -d "$GET_TIME" +'%Y'`
MM=`date -u -d "$GET_TIME" +'%m'`
DD=`date -u -d "$GET_TIME" +'%d'`
HH=`date -u -d "$GET_TIME" +'%H'`
YYYYMMDDHH="$YYYY$MM$DD$HH"
YYYYMMDD=${YYYYMMDDHH:0:8}

mkdir -p ${datadir}/msm/$YYYYMMDDHH
cd ${datadir}/msm/$YYYYMMDDHH

cfiles=MSM${YYYYMMDDHH}S.nc
cfilep=MSM${YYYYMMDDHH}P.nc

bash $wkdir/run/grads/convert.sh "$datadir/msm/${YYYYMMDDHH}" 

### hourly plot
t=0
while ((t <= 3)); do ### extended ?
tf=`printf '%03d' $t`
TIME_fcst=`date -ud "${t} hour $YYYY-$MM-$DD $HH" +'%Y-%m-%d %H:%M:%S'`
YYYYMMDDHHMMSS_fcst=`date -ud "$TIME_fcst" +'%Y%m%d%H%M%S'`
bash $wkdir/run/plot/plot.sh "$TIME_fcst" "$GET_TIME" $((t+1)) "$datadir/msm/${YYYYMMDDHH}" 
bash $wkdir/run/plot/plot_d3.sh "$TIME_fcst" "$GET_TIME" $((t+1)) "$datadir/msm/${YYYYMMDDHH}" 
t=$((t+1))
done

