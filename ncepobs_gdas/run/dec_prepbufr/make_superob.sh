#!/bin/bash -l

source ~/.bashrc

if [ "$1" == "" ] ; then
  echo "specify YYYYMMDDHH"
  exit 1
fi

timef3="${1:0:10}"
timef2=${timef3}0000

#----

wkdir="$( cd "$( dirname "$0" )" && pwd )"
cd ${wkdir}

datadir=${wkdir}/../../../ncepobs_gdas_letkf

rm -f fort.90

ln -s ${datadir}/${timef3}/obs_${timef2}.dat fort.90 

SOBIN="${wkdir}/superob/exe_superob"

[ ! -f exe_superob ] && ln -s $SOBIN exe_superob

./exe_superob
touch fort.91

mkdir -p ${datadir}/superob/${timef3}
mv fort.91 ${datadir}/superob/${timef3}/obs_${timef2}.dat




