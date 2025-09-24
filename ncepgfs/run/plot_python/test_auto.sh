#!/bin/sh 

source ${HOME}/.bashrc

echo "which python" $(which python)

wkdir="$( cd "$( dirname "$0" )" && pwd )"

cd ${wkdir}
#echo "call python"
#python ./test_draw.py 

echo "call other python"
/data_ballantine01/miyoshi-t/amemiya/escape_home/Lib/anaconda3/bin/python ./draw_gfs.py 20240601000000
echo "done with Argentina."
/data_ballantine01/miyoshi-t/amemiya/escape_home/Lib/anaconda3/bin/python ./draw_gfs_Japan.py 20240601000000
echo "done with Japan."
