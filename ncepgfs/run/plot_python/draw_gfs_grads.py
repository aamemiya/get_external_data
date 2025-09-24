#print("hello 1")
import sys
import numpy as np
import scipy as sp
import scipy.ndimage
import matplotlib.pyplot as plt
from mpl_toolkits import basemap  
from mpl_toolkits.basemap import Basemap,cm 
from scale_io import *
#sys.path.append("/data9/amemiya/PREVENIR/util/python")
import my_cmap

nlon=720
nlat=361

lonl=-90.0
lonr=-40.0
latl=-55.0
latr=-15.0

ilevref=5 #3000m

# load data

path="../../../ncepgfs_grads/2023010100/sfc_20230101060000.grd"

dtype=np.dtype('>f') ### big endian

vread=np.fromfile(path,dtype=dtype)

irec=0
msl=vread[irec*nlon*nlat:(irec+1)*nlon*nlat].reshape(nlat,nlon)
print("max min MSLP ", np.max(msl), np.min(msl))

irec=2
u2m=vread[irec*nlon*nlat:(irec+1)*nlon*nlat].reshape(nlat,nlon)
print("max min U2m ", np.max(u2m), np.min(u2m))
irec=3
v2m=vread[irec*nlon*nlat:(irec+1)*nlon*nlat].reshape(nlat,nlon)
print("max min V2m ", np.max(v2m), np.min(v2m))

irec=4
t2m=vread[irec*nlon*nlat:(irec+1)*nlon*nlat].reshape(nlat,nlon)
print("max min T2m ", np.max(t2m), np.min(t2m))
##irec=44
#apcp_sfc_tot=vread[irec*nlon*nlat:(irec+1)*nlon*nlat].reshape(nlat,nlon) ### kg/m^2 -> mm
#print("max min APCPsfc", np.max(apcp_sfc_tot), np.min(apcp_sfc_tot))

path="../../../ncepgfs_grads/2022040100/atm_20220401060000.grd"
dtype=np.dtype('>f') ### big endian
vread=np.fromfile(path,dtype=dtype)

#for j in range(100): 
#  irec=j
#  print("max min",j,np.max(vread[irec*nlon*nlat:(irec+1)*nlon*nlat]),np.min(vread[irec*nlon*nlat:(irec+1)*nlon*nlat]) )
#quit()

nlev=40

irec=12
hgt_500=vread[irec*nlon*nlat:(irec+1)*nlon*nlat].reshape(nlat,nlon)
print("max min hgt 500 ", np.max(hgt_500), np.min(hgt_500))

irec=5+1*nlev
u_850=vread[irec*nlon*nlat:(irec+1)*nlon*nlat].reshape(nlat,nlon)
print("max min U 850 ", np.max(u_850), np.min(u_850))

irec=5+2*nlev
v_850=vread[irec*nlon*nlat:(irec+1)*nlon*nlat].reshape(nlat,nlon)
print("max min V 850 ", np.max(v_850), np.min(v_850))

irec=5+3*nlev
t_850=vread[irec*nlon*nlat:(irec+1)*nlon*nlat].reshape(nlat,nlon)
print("max min T 850 ", np.max(t_850), np.min(t_850))

irec=5+4*nlev
rh_850=vread[irec*nlon*nlat:(irec+1)*nlon*nlat].reshape(nlat,nlon)
print("max min RH 850 ", np.max(rh_850), np.min(rh_850))

# (1000/850)^(rd/cp) := 1.0476
tlk = 55.0 + 1.0 / (1.0/(t_850-55.0) - (np.log(rh_850/100.0)) / 2840.0 ) 
qv = 0.622 * rh_850 * 0.01 * (6.11 * (10**(7.5*(t_850-273.15)/(t_850-35.8) ) ))  / 850.0
theq_850 = t_850 * 1.0476 * np.exp(2.675 * 1000 * qv / tlk )
print("max min theta eq 850 ", np.max(theq_850), np.min(theq_850))

def shift_array(array2d,smth=1.0) : 
  array_copy=sp.ndimage.gaussian_filter(array2d, (smth,smth), mode="constant")
  array2d_out=np.copy(array2d)
  array2d_out[:,0:int(nlon/2)]=array_copy[:,int(nlon/2):]
  array2d_out[:,int(nlon/2):]=array_copy[:,0:int(nlon/2)]
  return array2d_out

msl=shift_array(msl*0.01, smth=2.0)
t2m=shift_array(t2m-273.15)
u2m=shift_array(u2m)
v2m=shift_array(v2m)
theq_850=shift_array(theq_850)
t_850=shift_array(t_850-273.15)
u_850=shift_array(u_850)
v_850=shift_array(v_850)
rh_850=shift_array(rh_850)

lon1=np.arange(-180,180,0.5)
lat1=np.arange(-90,90.5,0.5)

lons=np.zeros((nlat,nlon))
lats=np.zeros((nlat,nlon))
for i in range(nlat):
    lons[i,:]=np.array(lon1)
for j in range(nlon): 
    lats[:,j]=np.array(lat1)
 
dlon=0.5
dlat=0.5
 
ilonl=max(int((lonl-lon1[0])/dlon),1)
ilonr=min(int((lonr-lon1[0])/dlon),nlon)
ilatl=max(int((latl-lat1[0])/dlat),1)
ilatr=min(int((latr-lat1[0])/dlat),nlat)

# Lambert Conformal Conic map.
fig,ax=plt.subplots()
mp=my_cmap.makemap(ax,lonl,lonr,latl,latr)

x, y = mp(lons[ilatl:ilatr,ilonl:ilonr], lats[ilatl:ilatr,ilonl:ilonr]) # compute map proj coordinates.

# draw filled contours.

cs = mp.contour(x,y,msl[ilatl:ilatr,ilonl:ilonr],levels=my_cmap.msl_levels,norm=my_cmap.msl_norm,linewidths=1.0)
#csf = mp.contourf(x,y,t2m[ilatl:ilatr,ilonl:ilonr],levels=my_cmap.t2m_levels,norm=my_cmap.t2m_norm, cmap=my_cmap.t2m_colormap)

#mp.clabel(cs,cs.levels)
# add colorbar.
#cbar = mp.colorbar(csf,location='bottom',pad="15%")
#cbar.set_label('C')

ax.clabel(cs,cs.levels,fontsize="small")

plt.title('MSLP')
figname="mslp.png"
fig.savefig(figname)
plt.clf()

# Lambert Conformal Conic map.
fig,ax=plt.subplots()
mp=my_cmap.makemap(ax,lonl,lonr,latl,latr)

x, y = mp(lons[ilatl:ilatr,ilonl:ilonr], lats[ilatl:ilatr,ilonl:ilonr]) # compute map proj coordinates.

# draw filled contours.

#cs = mp.contour(x,y,msl[ilatl:ilatr,ilonl:ilonr],levels=my_cmap.msl_levels,norm=my_cmap.msl_norm,linewidths=1.0)
csf = mp.contourf(x,y,t2m[ilatl:ilatr,ilonl:ilonr],levels=my_cmap.t2m_levels,norm=my_cmap.t2m_norm, cmap=my_cmap.t2m_colormap,extend="both")

#mp.clabel(cs,cs.levels)
# add colorbar.
cbar = mp.colorbar(csf,location='bottom',pad="15%")
cbar.set_label('C')

#ax.clabel(cs,cs.levels,fontsize="small")

plt.title('T2m')
figname="t2m.png"
fig.savefig(figname)
plt.clf()


# Lambert Conformal Conic map.
fig,ax=plt.subplots()
mp=my_cmap.makemap(ax,lonl,lonr,latl,latr)

x, y = mp(lons[ilatl:ilatr,ilonl:ilonr], lats[ilatl:ilatr,ilonl:ilonr]) # compute map proj coordinates.

ye=np.copy(y)
### dummy Y evenly-spaced coord
for j in range(y.shape[-1]):
  ysta=y[0,0]
  yend=y[-1,0]
  yinc=(yend-ysta)/float(y.shape[0]-1)
  yend=yend+yinc
  ye[:,j] = np.arange(ysta,yend,yinc)
# draw filled contours.

u2me=basemap.interp(u2m[ilatl:ilatr,ilonl:ilonr],x[0,:],y[:,0],x,ye,order=0)
v2me=basemap.interp(v2m[ilatl:ilatr,ilonl:ilonr],x[0,:],y[:,0],x,ye,order=0)

csf = mp.contourf(x,y,np.sqrt(u2m[ilatl:ilatr,ilonl:ilonr]**2+v2m[ilatl:ilatr,ilonl:ilonr]**2),levels=my_cmap.u2m_abs_levels,norm=my_cmap.u2m_abs_norm, cmap=my_cmap.u2m_abs_colormap,extend="max")
#csv = mp.streamplot(x,y,u2m[ilatl:ilatr,ilonl:ilonr],v2m[ilatl:ilatr,ilonl:ilonr])
csv = mp.streamplot(x,ye,u2me,v2me,color="black",linewidth=1.0,density=1.5)

#mp.clabel(cs,cs.levels)
# add colorbar.
cbar = mp.colorbar(csf,location='bottom',pad="15%")
cbar.set_label('m/s')

#ax.clabel(cs,cs.levels,fontsize="small")

plt.title('U,V 2m')
figname="uabs2m.png"
fig.savefig(figname)
plt.clf()


# Lambert Conformal Conic map.
fig,ax=plt.subplots()
mp=my_cmap.makemap(ax,lonl,lonr,latl,latr)

#x, y = mp(lons[ilatl:ilatr,ilonl:ilonr], lats[ilatl:ilatr,ilonl:ilonr]) # compute map proj coordinates.

#ye=np.copy(y)
### dummy Y evenly-spaced coord
#for j in range(y.shape[-1]):
#  ysta=y[0,0]
#  yend=y[-1,0]
#  yinc=(yend-ysta)/float(y.shape[0]-1)
#  yend=yend+yinc
#  ye[:,j] = np.arange(ysta,yend,yinc)
# draw filled contours.

ue=basemap.interp(u_850[ilatl:ilatr,ilonl:ilonr],x[0,:],y[:,0],x,ye,order=0)
ve=basemap.interp(v_850[ilatl:ilatr,ilonl:ilonr],x[0,:],y[:,0],x,ye,order=0)

cs = mp.contour(x,y,theq_850[ilatl:ilatr,ilonl:ilonr],levels=my_cmap.theq_levels,norm=my_cmap.theq_norm,colors=my_cmap.theq_colors,linewidths=1.0)
csv = mp.streamplot(x,ye,ue,ve,color="black",linewidth=1.0,density=1.5)

ax.clabel(cs,cs.levels,fontsize="small",colors="black")

#mp.clabel(cs,cs.levels)
# add colorbar.
#cbar = mp.colorbar(csf,location='bottom',pad="15%")
#cbar.set_label('m/s')

#ax.clabel(cs,cs.levels,fontsize="small")

plt.title('U,V theta eq. 850hPa')
figname="theq850.png"
fig.savefig(figname)
plt.clf()


# Lambert Conformal Conic map.
fig,ax=plt.subplots()
mp=my_cmap.makemap(ax,lonl,lonr,latl,latr)

#x, y = mp(lons[ilatl:ilatr,ilonl:ilonr], lats[ilatl:ilatr,ilonl:ilonr]) # compute map proj coordinates.

#ye=np.copy(y)
### dummy Y evenly-spaced coord
#for j in range(y.shape[-1]):
#  ysta=y[0,0]
#  yend=y[-1,0]
#  yinc=(yend-ysta)/float(y.shape[0]-1)
#  yend=yend+yinc
#  ye[:,j] = np.arange(ysta,yend,yinc)

## draw filled contours.

#ue=basemap.interp(u_850[ilatl:ilatr,ilonl:ilonr],x[0,:],y[:,0],x,ye,order=0)
#ve=basemap.interp(v_850[ilatl:ilatr,ilonl:ilonr],x[0,:],y[:,0],x,ye,order=0)

cs = mp.contour(x,y,t_850[ilatl:ilatr,ilonl:ilonr],levels=my_cmap.t2m_levels -10.0 ,norm=my_cmap.t2m_norm, colors="#800000",linewidths=1.0)
csf = mp.contourf(x,y,rh_850[ilatl:ilatr,ilonl:ilonr],levels=my_cmap.rh_levels,norm=my_cmap.rh_norm, cmap=my_cmap.rh_colormap,extend="max")
csv = mp.streamplot(x,ye,ue,ve,color="black",linewidth=1.0,density=1.5)

ax.clabel(cs,cs.levels,fontsize="small")

#mp.clabel(cs,cs.levels)
# add colorbar.
cbar = mp.colorbar(csf,location='bottom',pad="15%")
cbar.set_label('%')

#ax.clabel(cs,cs.levels,fontsize="small")

plt.title('U,V,T,RH 850hPa')
figname="t850.png"
fig.savefig(figname)
plt.clf()


