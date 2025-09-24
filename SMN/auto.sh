#!/bin/bash

myname=$(realpath $0)
wkdir=$(dirname $myname)

cd ${wkdir}
now=`date -u +'%Y-%m-%d %H:%M:%S'`

if [ ! -s "${wkdir}/mtime" ]; then
  echo "$now [ERR ] Cannot find previous model time."
  exit
fi

if [ -e "${wkdir}/running" ]; then
  echo "$now [PREV]" >> ${wkdir}/log_auto
  exit
else
  echo $$ > ${wkdir}/running
fi

PREVIOUS_TIME=$(cat ${wkdir}/mtime)
GET_TIME=$(date -ud "+ 6 hour ${PREVIOUS_TIME}" +'%Y-%m-%d %H')
TIME=$(date -ud "${GET_TIME}" +'%Y%m%d%H%M%S')

cd $wkdir
now=$(date -u +'%Y-%m-%d %H:%M:%S')
echo "$now [GET] $TIME" >> ${wkdir}/log_auto

./get_data_from_aws.sh $TIME &> log_get

#if [ "$(/bin/ls -x ${wkdir}/data/${TIME}/*_072.nc)" != "" ]; then
if [ ! -n "$(find ${wkdir}/data/${TIME} -maxdepth 0 -empty)" ]; then
  now=$(date -u +'%Y-%m-%d %H:%M:%S')
  echo "$now [PLOT] $TIME" >> ${wkdir}/log_auto
  ./plot.sh $TIME &> log_plot
#  if [ "$(/bin/ls -x ${wkdir}/plot_python/png/${TIME}/*_f072.png)" != "" ]; then
  if [ ! -n "$(find ${wkdir}/plot_python/png/${TIME} -maxdepth 0 -empty)" ]; then
    now=$(date -u +'%Y-%m-%d %H:%M:%S')
    echo "$now [DONE] $TIME" >> ${wkdir}/log_auto
    echo "$GET_TIME" > ${wkdir}/mtime
  else
    now=$(date -u +'%Y-%m-%d %H:%M:%S')
    echo "$now [ERR] $TIME" >> ${wkdir}/log_auto
  fi
else
  TIMEnext=$(date -ud "6 hours ${GET_TIME}" +'%Y%m%d%H%M%S')
  ./get_data_from_aws.sh $TIMEnext 1 ### dry run
  res=$?
  echo $TIMEnext $res
  if [ "$res" == 0 ] ;then
    echo "$now [SKIP] $TIME" >> ${wkdir}/log_auto
    echo "$GET_TIME" > ${wkdir}/mtime
  else
    now=$(date -u +'%Y-%m-%d %H:%M:%S')
    echo "$now [ERR] $TIME" >> ${wkdir}/log_auto
  fi
fi

rm -f ${wkdir}/running    
