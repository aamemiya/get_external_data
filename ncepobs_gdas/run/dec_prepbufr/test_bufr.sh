#!/bin/bash -l

source ~/.bashrc

tt="2025-08-26 00"

#----

wkdir="$( cd "$( dirname "$0" )" && pwd )"
cd ${wkdir}
prepbufrdir="$wkdir/test_in"
outdir="$wkdir/test_out"

BUFRBIN="$wkdir/prepbufr/bufrlib/10.1.0_intel/bin/"

timef=$(date -ud "$tt" '+%Y-%m-%d %H')
timef2=$(date -ud "$tt" '+%Y%m%d%H%M%S')
timef3=$(date -ud "$tt" '+%Y%m%d%H')
echo "[$timef]"

outdir_s=$outdir/superob
outdir_satreps=$outdir/satreps
outdir_satreps_s=$outdir/satreps/superob


rm -f prepbufr.in fort.90


#file="$prepbufrdir/prepbufr.${timef3}"
file="../../${timef3}/prepbufr.${timef3}"

#echo $file
#exit

wc -c "$file" | $BUFRBIN/grabbufr "$file" prepbufr.in

[ -f fort.90 ] && rm fort.90


###rm exec_dec_prepbufr.sh.e*
###rm exec_dec_prepbufr.sh.o*

###cp template.sh  exec_dec_prepbufr.sh
###echo "mkdir -p $outdir" >> exec_dec_prepbufr.sh
###echo "mv fort.90 $outdir/obs_${timef2}.dat" >> exec_dec_prepbufr.sh
##### must be executed on calc node ; otherwise AVX512 is not supported
###pjsub ./exec_dec_prepbufr.sh

#module load hdf5/1.10.5
#module load netcdf/4.7.0
#module load netcdf-fortran/4.4.5

DECBIN="/data9/amemiya/fortran/SCALE-LETKF/util/prepbufr/dec_prepbufr"
SOBIN="${wkdir}/superob/exe_superob"

[ ! -f dec_prepbufr_fixed ] && ln -s $DECBIN dec_prepbufr_fixed
[ ! -f exe_superob ] && ln -s $SOBIN exe_superob

./dec_prepbufr_fixed
touch fort.90

./exe_superob
touch fort.91

mkdir -p $outdir
mv fort.90 $outdir/obs_${timef2}.dat

mkdir -p $outdir_s
mv fort.91 $outdir_s/obs_${timef2}.dat

./dec_prepbufr_satreps
touch fort.90

./exe_superob
touch fort.91

mkdir -p $outdir_satreps
mv fort.90 $outdir_satreps/obs_${timef2}.dat

mkdir -p $outdir_satreps_s
mv fort.91 $outdir_satreps_s/obs_${timef2}.dat




