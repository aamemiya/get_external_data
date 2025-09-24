icc -c -axMIC-AVX512 -DDYNAMIC_ALLOCATION -DMAXNC=600 -DMXNAF=3 -DUNDERSCORE *.c
ifort -c -axMIC-AVX512 `./getdefflags_F.sh` -DUNDERSCORE modv*.F moda*.F `ls -1 *.F *.f | grep -v "mod[av]_"`
