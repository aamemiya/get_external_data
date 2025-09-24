import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.basemap import Basemap,cm 
from scale_io import *
import sys
sys.path.append("/data/amemiya/util/python")
import my_cmap

it=int(sys.argv[1])

lonl=-68.0
lonr=-60.0

latl=-35.0
latr=-28.0

# Lambert Conformal Conic map.
m = Basemap(llcrnrlon=lonl,llcrnrlat=latl,urcrnrlon=lonr,urcrnrlat=latr,
            projection='merc',lat_0=0.5*(latl+latr),lon_0=0.5*(lonl+lonr),lat_ts=0.5*(latl+latr),
            rsphere=(6378137.00,6356752.3142),
            resolution ='l')

# load data

path="/data/amemiya/test_draw_nc/history_merge"

nproc, rootgrps, dimdef = scale_open(path, 'r+')

vardim, vread = scale_read(nproc, rootgrps, dimdef, 'T', t=it)
vardimz, vreadz = scale_read(nproc, rootgrps, dimdef, 'z')
vardimt, vtopo = scale_read(nproc, rootgrps, dimdef, 'topo')

#vread = np.fromfile(path,dtype=dtype).reshape(nlat,nlon)

#ilevref=0 #1000m
#ilevref=1 #2000m
#ilevref=2 #3000m
ilevref=4 #5000m

vdraw=vread[ilevref] 

print('vread max min',vread.max(),vread.min())
print('vdraw max min',vdraw.max(),vdraw.min())

lon1=dimdef['coor_g']['lon']
lat1=dimdef['coor_g']['lat']

nlon=dimdef['len']['lon'][0]
nlat=dimdef['len']['lat'][0]
nlev=dimdef['len']['z'][0]
#print("nlev, nlat, nlon",nlev,nlat,nlon)
#for i in range(nlev) : 
#      print(i,vreadz[i],np.nanmax(vread[i,:]),np.nanmin(vread[i,:]))
#quit()

lons=np.zeros((nlat,nlon))
lats=np.zeros((nlat,nlon))
for i in range(nlat):
    lons[i,:]=np.array(lon1)
for j in range(nlon): 
    lats[:,j]=np.array(lat1)

dlon=(lon1[-1]-lon1[0])/float(nlon-1)
dlat=(lat1[-1]-lat1[0])/float(nlat-1)


ilonl=max(int((lonl-lon1[0])/dlon),1)
ilonr=min(int((lonr-lon1[0])/dlon),nlon)
ilatl=max(int((latl-lat1[0])/dlat),1)
ilatr=min(int((latr-lat1[0])/dlat),nlat)

#print(nlon,nlat)
#print(ilonl,ilonr,ilatl,ilatr)
#quit()
#
x, y = m(lons[ilatl:ilatr,ilonl:ilonr], lats[ilatl:ilatr,ilonl:ilonr]) # compute map proj coordinates.

# draw coastlines, meridians and parallels.
m.drawcoastlines()
m.drawcountries()
m.drawmapboundary()
m.drawrivers()
m.readshapefile('/data/amemiya/shapefiles/provincias_geog',name='provincia')

#m.drawmapboundary(fill_color='#99ffff')
#m.fillcontinents(color='#cc9966',lake_color='#99ffff')

# draw filled contours.

#clevs = [0,1,2.5,5,7.5,10,15,20,30,40,50,70,100,150,200,250,300]
clevs_topo = range(500,3000,500)
clevs = range(245,285,2)
#cs = m.contourf(x,y,vdraw[ilatl:ilatr,ilonl:ilonr],levels=clevs,cmap=cm.s3pcpn)
cc = m.contour(x,y,vtopo[ilatl:ilatr,ilonl:ilonr],levels=clevs_topo,colors='black', linewidths=0.8)
cs = m.contourf(x,y,vdraw[ilatl:ilatr,ilonl:ilonr],levels=clevs,cmap="gist_rainbow_r")
#cs = m.imshow(x,y,vdraw[ilatl:ilatr,ilonl:ilonr],levels=clevs)
# add colorbar.
cbar = m.colorbar(cs,location='bottom',pad="15%")
#cbar.set_label('mm')
cbar.set_label('K')

m.drawparallels(np.arange(-40,-20,2),labels=[1,1,0,0])
m.drawmeridians(np.arange(-80,-60,2),labels=[0,0,0,1])
plt.title('Temperature ' + str(int(vreadz[ilevref])) + ' m')
#plt.show()
plt.savefig("out_"+ str(it).rjust(3,'0') +".png")
