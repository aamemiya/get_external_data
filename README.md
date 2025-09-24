# get_external_data
scripts to get and plot external meteorological data

## data source

- NCEP GFS 
- NCEP GDAS PREPBUFR
- JMA MSM
- Servicio Meteorológico Nacional (SMN) de Argentina

## dependency

- wgrib2
- bufrlib (old version 10.1.0 intel - avaiable on macallan)
- python libraries
  + NetCDF4
  + numpy, scipy
  + matplotlib
  + basemap

## prepare large data

### climatological data 

make a link of (or copy) climatological data which is necessary for the plot  

```
ln -s /data_aip01/amemiya/SCALE-LETKF-rt-archive/realtime/external/clim ncepgfs/
ln -s /data_aip01/amemiya/SCALE-LETKF-rt-archive/realtime/external/clim SMN/plot_python/
```



