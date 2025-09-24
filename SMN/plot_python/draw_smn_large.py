#print("hello 1")
import sys
import numpy as np
import scipy as sp
import scipy.ndimage
from scipy.interpolate import NearestNDInterpolator
import matplotlib.pyplot as plt
from mpl_toolkits import basemap  
from mpl_toolkits.basemap import Basemap,cm 
import my_cmap
import pygrib
import datetime 
import netCDF4 

#nlon=720
#nlat=361

ctime=sys.argv[1]

def shift_array(array2d,smth=1.0) : 
  array_copy=sp.ndimage.gaussian_filter(array2d, (smth,smth), mode="reflect")
  array2d_out=np.copy(array_copy)
#  array2d_out[:,0:int(nlon/2)]=array_copy[::-1,int(nlon/2):]
#  array2d_out[:,int(nlon/2):]=array_copy[::-1,0:int(nlon/2)]
  return array2d_out

#ncfile=nc.Dataset("../../clim/air.2m.4Xday.ltm.1991-2020.nc")
ncfile=netCDF4.Dataset("./clim/air.4Xday.ltm.nc")
lon1_clim=ncfile.variables['lon'][:]
lat1_clim=ncfile.variables['lat'][:]
t2m_clim=ncfile.variables['air'][:]

lonl=-90.0
lonr=-40.0
latl=-55.0
latr=-15.0

topo=np.load("../data/grid_topo/topo.npy")
lats=np.load("../data/grid_topo/lat.npy")
lons=np.load("../data/grid_topo/lon.npy")

itime=datetime.datetime.strptime(ctime,'%Y%m%d%H%M%S')
vtime=itime
savedir='./png/'+ctime+'/'

dh=1
dtime=datetime.timedelta(hours=dh)

dtimemax=datetime.timedelta(hours=72)
vtimeend=itime+dtimemax+dtime

day=vtime.strftime('%Y%m%d')
hr=vtime.strftime('%H')
ih=0

while not vtime == vtimeend :

 print(vtime.strftime('%Y%m%d%H%M%S') + "...")

# load data
 
 ch="_f"+str(ih).zfill(3)
 ch2="_"+str(ih).zfill(3)

 path="../data/"+ctime+"/WRFDETAR_01H_"+day+"_"+hr+ch2+".nc"

 nc=netCDF4.Dataset(path,'r',format='NETCDF')

 if ih == 0 :
#   lat2=np.array(nc.variables['lat'][:])
#   lon2=np.array(nc.variables['lon'][:])
#   lons=lon2
#   lats=lat2
#
   ilonl=0
   ilatl=0
   ilatr,ilonr=lats.shape
  # lon1=np.arange(-180,180,0.5)
  # lat1=np.arange(-90,90.5,0.5)

  # lons=np.zeros((nlat,nlon))
  # lats=np.zeros((nlat,nlon))
  # for i in range(nlat):
  #    lons[i,:]=np.array(lon1)
  # for j in range(nlon): 
  #    lats[:,j]=np.array(lat1)

  # dlon=0.5
  # dlat=0.5
 
  # ilonl=max(int((lonl-lon1[0])/dlon),1)
  # ilonr=min(int((lonr-lon1[0])/dlon),nlon)
  # ilatl=max(int((latl-lat1[0])/dlat),1)
  # ilatr=min(int((latr-lat1[0])/dlat),nlat)

 prec1h=np.array(nc.variables['PP'][:][0])
 print("max min prec 1h ", np.max(prec1h), np.min(prec1h))
 msl=np.array(nc.variables['PSFC'][:][0])

# print(msl[0,0],msl[0,-1],msl[-1,0],msl[-1,-1])
# quit()
 print("max min PSFC ", np.max(msl), np.min(msl))
# msl=msl*(293 / (293 - topo * 0.0065))
 msl=msl*( ( 270 + 0.0065 * topo ) / 270 ) ** ( 9.81 / ( 287.04 * 0.0065 ) )
 print("max min MSLP", np.max(msl), np.min(msl))
 msl=shift_array(msl,smth=10.0)
#
 print("max min MSLP after smth", np.max(msl), np.min(msl))

 t2m=np.array(nc.variables['T2'][:][0])
 print("max min T2m ", np.max(t2m), np.min(t2m))

 t2m=shift_array(t2m,smth=10)
 
 uabs10m=np.array(nc.variables['magViento10'][:][0])
 udir10m=np.array(nc.variables['dirViento10'][:][0])

 uabs10m=shift_array(uabs10m,smth=10)
 udir10m=shift_array(udir10m,smth=10)
 
 deg2rad=np.pi/180.0
 u10m=uabs10m * np.cos(udir10m*deg2rad)
 v10m=uabs10m * np.sin(udir10m*deg2rad)
 print("max min U10m ", np.max(u10m), np.min(u10m))
 print("max min V10m ", np.max(v10m), np.min(v10m))
 
 
 if (np.mod(ih,6)==0):
   vtimesta=datetime.datetime.strptime(vtime.strftime('%Y')+"0101000000",'%Y%m%d%H%M%S')
   #j=int((vtime-vtimesta)/datetime.timedelta(hours=6)) - 1
   j=int((vtime-vtimesta)/datetime.timedelta(hours=6))
   if ( j >= 1460 ) : # temporary treatment of leap years
     j += -4 

#   print(t2m_clim[j,0:3,0:3])
   t2m_clim_reg=np.array(basemap.interp(t2m_clim[j,::-1,:],lon1_clim,lat1_clim[::-1],lons+360.0,lats,order=1))
#   print(t2m_clim_reg[0:3,0:3])
   t2m_clim_reg=shift_array(t2m_clim_reg[:,:]-273.15)
#   print(t2m_clim_reg[0:3,0:3])
#   quit()

# print("lon", lon2[0:3,0:3])
# print("lat", lat2[0:3,0:3])
# quit()

# Lambert Conformal Conic map.
 fig,ax=plt.subplots()
 mp=my_cmap.makemap(ax,lonl,lonr,latl,latr)
 xl, yl = mp([lonl], [latl])
 xr, yr = mp([lonr], [latr])

 xl=xl[0]
 yl=yl[0]
 xr=xr[0]
 yr=yr[0]

 x, y = mp(lons[ilatl:ilatr,ilonl:ilonr], lats[ilatl:ilatr,ilonl:ilonr]) # compute map proj coordinates.
 xful, yful = mp(lons, lats) # compute map proj coordinates.

# draw filled contours.

 cs = mp.contour(x,y,msl[ilatl:ilatr,ilonl:ilonr],levels=my_cmap.msl_levels,norm=my_cmap.msl_norm,linewidths=1.0)
 csf = mp.contourf(x,y,prec1h[ilatl:ilatr,ilonl:ilonr],levels=my_cmap.precip_levels,norm=my_cmap.precip_norm, cmap=my_cmap.precip_colormap,extend="max")

#mp.clabel(cs,cs.levels)
# add colorbar.
 cbar = mp.colorbar(csf,location='bottom',pad="15%")
 cbar.set_label('mm/h')

 ax.clabel(cs,cs.levels,fontsize="small")

 ax.text(xl,yr*1.01, 'SMN OPE det',horizontalalignment='left',  verticalalignment='bottom',size="x-small")
 ax.text(xr,yr*1.01, 'init  '+itime.strftime('%d %H:%M:%S'),horizontalalignment='right', verticalalignment='bottom',size="xx-small")
 ax.text(xr,yr*1.035, 'valid '+vtime.strftime('%d %H:%M:%S'),horizontalalignment='right', verticalalignment='bottom',size="xx-small")
 plt.title('MSLP, 1h precip')
 figname=savedir+"prec"+ch+".png"
 fig.savefig(figname)
 plt.close()
 
# Lambert Conformal Conic map.

 fig,ax=plt.subplots()
 mp=my_cmap.makemap(ax,lonl,lonr,latl,latr)

# draw filled contours.

 cs = mp.contour(x,y,t2m[ilatl:ilatr,ilonl:ilonr],levels=my_cmap.t2m_levels, colors="black",linewidths=0.6)

 if (np.mod(ih,6)==0):
   csf = mp.contourf(x,y,t2m[ilatl:ilatr,ilonl:ilonr]-t2m_clim_reg[ilatl:ilatr,ilonl:ilonr],levels=my_cmap.dt2m_levels,norm=my_cmap.dt2m_norm, cmap=my_cmap.dt2m_colormap,extend="both")
 else: # dummy
   csf = mp.contourf(x,y,t2m[ilatl:ilatr,ilonl:ilonr]-t2m[ilatl:ilatr,ilonl:ilonr],levels=my_cmap.dt2m_levels,norm=my_cmap.dt2m_norm, cmap=my_cmap.dt2m_colormap,extend="both")

# add colorbar.
 cbar = mp.colorbar(csf,location='bottom',pad="15%")
 cbar.set_label('C')

 ax.clabel(cs,cs.levels,fontsize="small")

 ax.text(xl,yr*1.01, 'SMN OPE det',horizontalalignment='left',  verticalalignment='bottom',size="x-small")
 ax.text(xl,yr*1.04, 'clim: 1991-2020 GFS',horizontalalignment='left',  verticalalignment='bottom',size=5.0)
 ax.text(xr,yr*1.01, 'init  '+itime.strftime('%d %H:%M:%S'),horizontalalignment='right', verticalalignment='bottom',size="xx-small")
 ax.text(xr,yr*1.035, 'valid '+vtime.strftime('%d %H:%M:%S'),horizontalalignment='right', verticalalignment='bottom',size="xx-small")
 plt.title('T 2m')
 figname=savedir+"t2m"+ch+".png"
 fig.savefig(figname)
 plt.close()

# Lambert Conformal Conic map.
 fig,ax=plt.subplots()
 mp=my_cmap.makemap(ax,lonl,lonr,latl,latr)

 xe=np.linspace(np.min(x),np.max(x),100)
 ye=np.linspace(np.min(y),np.max(y),100)


 skip=4
 xe, ye = np.meshgrid(xe, ye)
 interpu=NearestNDInterpolator(list(zip(xful[::skip,::skip].ravel(),yful[::skip,::skip].ravel())),u10m[::skip,::skip].ravel()) 
 interpv=NearestNDInterpolator(list(zip(xful[::skip,::skip].ravel(),yful[::skip,::skip].ravel())),v10m[::skip,::skip].ravel()) 
 u10me=interpu(xe,ye) 
 v10me=interpv(xe,ye) 
#### dummy Y evenly-spaced coord
# for j in range(y.shape[-1]):
#  ysta=y[0,0]
#  yend=y[-1,0]
#  yinc=(yend-ysta)/float(y.shape[0]-1)
#  yend=yend+yinc
#  ye[:,j] = np.arange(ysta,yend,yinc)
#
# u10me=basemap.interp(u10m[ilatl:ilatr,ilonl:ilonr],x[0,:],y[:,0],x,ye,order=0)
# v10me=basemap.interp(v10m[ilatl:ilatr,ilonl:ilonr],x[0,:],y[:,0],x,ye,order=0)

## draw filled contours.

 csf = mp.contourf(x,y,uabs10m[ilatl:ilatr,ilonl:ilonr],levels=my_cmap.u10m_abs_levels,norm=my_cmap.u10m_abs_norm, cmap=my_cmap.u10m_abs_colormap,extend="max")
 csv = mp.streamplot(xe,ye,u10me,v10me,color="black",linewidth=1.0,density=1.5)

#mp.clabel(cs,cs.levels)
# add colorbar.
 cbar = mp.colorbar(csf,location='bottom',pad="15%")
 cbar.set_label('m/s')

 ax.text(xl,yr*1.01, 'SMN OPE det',horizontalalignment='left',  verticalalignment='bottom',size="x-small")
 ax.text(xr,yr*1.01, 'init  '+itime.strftime('%d %H:%M:%S'),horizontalalignment='right', verticalalignment='bottom',size="xx-small")
 ax.text(xr,yr*1.035, 'valid '+vtime.strftime('%d %H:%M:%S'),horizontalalignment='right', verticalalignment='bottom',size="xx-small")
 plt.title('U,V 10m')
 figname=savedir+"uabs10m"+ch+".png"
 fig.savefig(figname)
 plt.close()


 ih=ih+dh
 vtime=vtime+dtime
