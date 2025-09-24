#!/bin/sh

wkdir=`pwd`

PREVIOUS_TIME=`cat ${wkdir}/mtime_conv`
END_TIME=`cat ${wkdir}/mtime_conv_end`
PREVIOUS_TIME_NOSPACE=`date -u -d "${PREVIOUS_TIME}" +'%Y-%m-%d_%H'`
END_TIME_NOSPACE=`date -u -d "${END_TIME}" +'%Y-%m-%d_%H'`
while [ "$PREVIOUS_TIME_NOSPACE" != "$END_TIME_NOSPACE" ] ;do
 ./convert_plot.sh
 PREVIOUS_TIME=`cat ${wkdir}/mtime_conv`
 PREVIOUS_TIME_NOSPACE=`date -u -d "${PREVIOUS_TIME}" +'%Y-%m-%d_%H'`
done
