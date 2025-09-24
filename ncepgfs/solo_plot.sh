#!/bin/bash -l

wkdir="$( cd "$( dirname "$0" )" && pwd )"
datadir=$wkdir/../../external


cd ${wkdir}
now=`date -u +'%Y-%m-%d %H:%M:%S'`

if [ -e "${wkdir}/running" ]; then
  echo "$now [PREV]" >> ${wkdir}/conv_ncep_gfs.log
  exit
else
  touch ${wkdir}/running
fi

GET_TIME="$1"
YYYY=`date -u -d "$GET_TIME" +'%Y'`
MM=`date -u -d "$GET_TIME" +'%m'`
DD=`date -u -d "$GET_TIME" +'%d'`
HH=`date -u -d "$GET_TIME" +'%H'`
YYYYMMDDHH="$YYYY$MM$DD$HH"

echo "$now [TRY ] $YYYYMMDDHH" >> ${wkdir}/conv_ncep_gfs.log

mkdir -p ${wkdir}/$YYYYMMDDHH
cd ${wkdir}/$YYYYMMDDHH

allget=1

t=0
while ((t <= 15)); do

  tf=`printf '%03d' $t`
  TIME_fcst=`date -ud "${t} hour $YYYY-$MM-$DD $HH" +'%Y-%m-%d %H:%M:%S'`
  YYYYMMDDHHMMSS_fcst=`date -ud "$TIME_fcst" +'%Y%m%d%H%M%S'`

  allget=1

  if ((allget == 1)); then
    if [ ! -s "$wkdir/../ncepgfs_wrf/${YYYYMMDDHH}/mean/wrfout_${YYYYMMDDHHMMSS_fcst}" ]; then
#      now=`date -u +'%Y-%m-%d %H:%M:%S'`
#      echo "$now [CONV] $YYYYMMDDHH -> gfs.$YYYYMMDDHHMMSS_fcst - WPS" >> ${wkdir}/get_ncep_gfs.log
#      bash $wkdir/run/wps/convert.sh "$TIME_fcst" "$TIME_fcst" "$wkdir/${YYYYMMDDHH}/gfs" \
#       > ${wkdir}/convert_wps.log 2>&1

#      now=`date -u +'%Y-%m-%d %H:%M:%S'`
#      echo "$now [CONV] $YYYYMMDDHH -> gfs.$YYYYMMDDHHMMSS_fcst - WRF" >> ${wkdir}/get_ncep_gfs.log
#      bash $wkdir/run/wrf/convert.sh "$TIME_fcst" "$TIME_fcst" "$wkdir/../ncepgfs_wrf/${YYYYMMDDHH}/mean" \
#       > ${wkdir}/convert_wrf.log 2>&1

      now=`date -u +'%Y-%m-%d %H:%M:%S'`
      echo "$now [CONV] $YYYYMMDDHH -> gfs.$YYYYMMDDHHMMSS_fcst - GrADS" >> ${wkdir}/conv_ncep_gfs.log
      bash $wkdir/run/grads/convert.sh "$TIME_fcst" "$TIME_fcst" "$datadir/ncepgfs/${YYYYMMDDHH}/gfs" \
       > ${wkdir}/convert_grads.log 2>&1

      now=`date -u +'%Y-%m-%d %H:%M:%S'`
      echo "$now [CONV] $YYYYMMDDHH -> gfs.$YYYYMMDDHHMMSS_fcst - Plot (background job)" >> ${wkdir}/conv_ncep_gfs.log
      bash $wkdir/run/plot/plot.sh "$TIME_fcst" "$GET_TIME" $((t/6+1)) "$datadir/ncepgfs/${YYYYMMDDHH}/gfs" \
       > ${wkdir}/convert_plot.log 2>&1 

#      now=`date -u +'%Y-%m-%d %H:%M:%S'`
#      echo "$now [CONV] $YYYYMMDDHH -> gfs.$YYYYMMDDHHMMSS_fcst - Plot SH (background job)" >> ${wkdir}/conv_ncep_gfs.log
#      bash $wkdir/run/plot_SH/plot.sh "$TIME_fcst" "$GET_TIME" $((t/6+1)) "$datadir/ncepgfs/${YYYYMMDDHH}/gfs" \
#       > ${wkdir}/convert_plot.log 2>&1 &


#      now=`date -u +'%Y-%m-%d %H:%M:%S'`
#      echo "$now [CONV] $YYYYMMDDHH -> gfs.$YYYYMMDDHHMMSS_fcst - GrADS for SCALE" >> ${wkdir}/conv_ncep_gfs.log
#      bash $wkdir/run/grads_scale/convert.sh "$TIME_fcst" "$TIME_fcst" "$datadir/ncepgfs/${YYYYMMDDHH}/gfs" "$datadir/ncepgfs_grads/${YYYYMMDDHH}" \
#       > ${wkdir}/convert_grads_scale.log 2>&1
#
#      if [ ! -s "$wkdir/../ncepgfs_scale/${YYYYMMDDHH}/grads/${YYYYMMDDHHMMSS_fcst}.grd" ]; then
#        now=`date -u +'%Y-%m-%d %H:%M:%S'`
#        echo "$now [CONV] $YYYYMMDDHH -> gfs.$YYYYMMDDHHMMSS_fcst - SCALE_init" >> ${wkdir}/get_ncep_gfs.log
#        bash $wkdir/run/scale_init/convert.sh "$TIME_fcst" "$TIME_fcst" "$wkdir/../ncepgfs_wrf/${YYYYMMDDHH}/mean" "$wkdir/../ncepgfs_scale/${YYYYMMDDHH}" \
#         > ${wkdir}/convert_scale_init.log 2>&1
#      fi
    fi
  fi

t=$((t+3))
done

if ((allget == 1)); then
  now=`date -u +'%Y-%m-%d %H:%M:%S'`
  echo "$now [DONE] $YYYYMMDDHH" >> ${wkdir}/conv_ncep_gfs.log
fi

rm -f ${wkdir}/running
