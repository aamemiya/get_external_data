#!/bin/bash

myname=$(realpath $0)
wkdir=$(dirname $myname)

dawebdir="/home/amemiya/public_html/scale/data"

python="/data9/amemiya/Lib/miniconda3/envs/myenv/bin/python"

TIME=$1

cd $wkdir/plot_python
mkdir -p png/$TIME
$python draw_smn_large.py $TIME &
$python draw_smn_small.py $TIME

mogrify -trim png/$TIME/*.png

scp -r -i ~/.ssh/id_rsa_note png/$TIME daweb.r-ccs27.riken.jp:$dawebdir/smn_Argentina/
echo "plot "$ctimei" done." 
