#print("hello 1")
import sys
import numpy as np
import scipy as sp
import scipy.ndimage
import matplotlib.pyplot as plt
from mpl_toolkits import basemap  
from mpl_toolkits.basemap import Basemap,cm 
import my_cmap
import pygrib
import datetime 
import netCDF4 as nc

path="../data/sample/WRFDETAR_01H_20241127_12_001.nc"

nc=nc.Dataset(path,'r',format='NETCDF')
vprec=np.array(nc.variables['PP'][:][0])
vlat=np.array(nc.variables['lat'][:])
vlon=np.array(nc.variables['lon'][:])

print(np.max(vprec),vprec.shape)
print(np.max(vlat),vlat.shape)
print(np.max(vlon),vlon.shape)

