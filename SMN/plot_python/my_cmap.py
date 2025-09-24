import matplotlib
import numpy as np
from mpl_toolkits.basemap import Basemap 
nws_msl_colors = [
    "#04e9e7",  # 0.01 - 0.10 inches
    "#019ff4",  # 0.10 - 0.25 inches
    "#0300f4",  # 0.25 - 0.50 inches
    "#02fd02",  # 0.50 - 0.75 inches
    "#01c501",  # 0.75 - 1.00 inches
    "#008e00",  # 1.00 - 1.50 inches
    "#fdf802",  # 1.50 - 2.00 inches
    "#e5bc00",  # 2.00 - 2.50 inches
    "#fd9500",  # 2.50 - 3.00 inches
    "#fd0000",  # 3.00 - 4.00 inches
    "#d40000",  # 4.00 - 5.00 inches
    "#bc0000",  # 5.00 - 6.00 inches
    "#f800fd", 
    "#9854c6", 
    "#fdfdfd", 
]
msl_colormap = matplotlib.colors.ListedColormap(nws_msl_colors)

msl_levels = range(984,1040,4)
msl_norm=matplotlib.colors.BoundaryNorm(msl_levels, 15)

t500_levels = range(-45,0,3)
gph500_levels = range(4800,6000,60)
gph300_levels = range(8040,10800,120)

nws_precip_colors = [
    "#04e9e7",  # 0.01 - 0.10 inches
    "#019ff4",  # 0.10 - 0.25 inches
    "#0300f4",  # 0.25 - 0.50 inches
    "#02fd02",  # 0.50 - 0.75 inches
    "#01c501",  # 0.75 - 1.00 inches
    "#008e00",  # 1.00 - 1.50 inches
    "#fdf802",  # 1.50 - 2.00 inches
    "#e5bc00",  # 2.00 - 2.50 inches
    "#fd9500",  # 2.50 - 3.00 inches
    "#fd0000",  # 3.00 - 4.00 inches
    "#d40000",  # 4.00 - 5.00 inches
    "#bc0000",  # 5.00 - 6.00 inches
    "#f800fd", 
    "#9854c6", 
    "#fdfdfd", 
]
precip_colormap = matplotlib.colors.ListedColormap(nws_precip_colors)
precip_colormap.set_over(nws_precip_colors[-1])

precip_levels = [ 0.1, 0.2, 0.5, 1.0, 2.0, 5.0, 10.0, 20.0, 30.0, 40.0,50.0, 80.0, 100.0, 120.0, 999.0]
precip_norm=matplotlib.colors.BoundaryNorm(precip_levels, 15)

gauge_colors = [
    "#fdfdfd", 
    "#04e9e7",  # 0.01 - 0.10 inches
    "#0300f4",  # 0.25 - 0.50 inches
    "#02fd02",  # 0.50 - 0.75 inches
    "#008e00",  # 1.00 - 1.50 inches
    "#fdf802",  # 1.50 - 2.00 inches
    "#fd9500",  # 2.50 - 3.00 inches
    "#fd0000",  # 3.00 - 4.00 inches
    "#bc0000",  # 5.00 - 6.00 inches
    "#f800fd", 
    "#9854c6", 
]
gauge_colormap = matplotlib.colors.ListedColormap(gauge_colors)

gauge_levels = [ 0., 1., 2., 3., 4., 5., 6., 7., 8., 9.,99.]
gauge_norm=matplotlib.colors.BoundaryNorm(gauge_levels, 11)


ref_colors = [
    "#C0C0C0", 
    "#04e9e7",  # 0.01 - 0.10 inches
    "#02fd02",  # 0.50 - 0.75 inches
    "#fdf802",  # 1.50 - 2.00 inches
    "#fd0000",  # 3.00 - 4.00 inches
    "#bc0000",  # 5.00 - 6.00 inches
    "#ff00ff", 
]
ref_colormap = matplotlib.colors.ListedColormap(ref_colors)

ref_levels = [ 0, 10, 20, 30, 40, 50, 60 ]
ref_norm=matplotlib.colors.BoundaryNorm(ref_levels, 7)

rh_colors = [
    "#66ff66",  
    "#66ffff",  
    "#66b3ff",  
    "#6666ff", 
]
rh_colormap = matplotlib.colors.ListedColormap(rh_colors)

rh_levels = [ 60, 70, 80, 90, 100 ]
rh_norm=matplotlib.colors.BoundaryNorm(rh_levels, 5)


theq_colors = [
    "#9933ff", 
    "#6633ff",  
    "#3333ff",  
    "#3366ff",  
    "#3399ff",  
    "#33ccff",  
    "#33ffcc",  
    "#33ff99",  
    "#33ff66",  
    "#33ff33",  
    "#66ff33",  
    "#ccff33",  
    "#ffff33",  
    "#ffcc33",  
    "#ff9933",  
    "#ff6633",  
    "#ff3333",  
    "#ff0000",  
]
theq_colormap = matplotlib.colors.ListedColormap(theq_colors)
theq_colormap.set_over(theq_colors[-1])
theq_colormap.set_under(theq_colors[0])

theq_levels = np.arange(284,360,4)
theq_norm=matplotlib.colors.BoundaryNorm(theq_levels, len(theq_levels))


t2m_colors = [
    "#9933ff", 
    "#6633ff",  
    "#3333ff",  
    "#3366ff",  
    "#3399ff",  
    "#33ccff",  
    "#33ffcc",  
    "#33ff99",  
    "#33ff66",  
    "#33ff33",  
    "#66ff33",  
    "#ccff33",  
    "#ffff33",  
    "#ffcc33",  
    "#ff9933",  
    "#ff6633",  
    "#ff3333",  
]
t2m_colormap = matplotlib.colors.ListedColormap(t2m_colors[1:-1])
t2m_colormap.set_over(t2m_colors[-1])
t2m_colormap.set_under(t2m_colors[0])

t2m_levels = np.arange(-10,35,3)
t2m_norm=matplotlib.colors.BoundaryNorm(t2m_levels, len(t2m_levels))

dt2m_colors = [
    "#000066", 
    "#0000cc", 
    "#0000ff", 
    "#0066ff",  
    "#3399ff",  
    "#66ccff",  

    "#ffffff", 
    "#ffffff", 

    "#ffff99", 
    "#ffcc66", 
    "#ff9933", 
    "#ff3300",  
    "#ff0000",  
    "#800000",  
]
dt2m_colormap = matplotlib.colors.ListedColormap(dt2m_colors[1:-1])
dt2m_colormap.set_over(dt2m_colors[-1])
dt2m_colormap.set_under(dt2m_colors[0])

dt2m_levels = np.arange(-12,14,2)
dt2m_norm=matplotlib.colors.BoundaryNorm(dt2m_levels, len(dt2m_levels))


u10m_colors = [
    "#C0C0C0", 
    "#04e9e7",  # 0.01 - 0.10 inches
    "#02fd02",  # 0.50 - 0.75 inches
    "#fdf802",  # 1.50 - 2.00 inches
    "#fd0000",  # 3.00 - 4.00 inches
    "#bc0000",  # 5.00 - 6.00 inches
    "#ff00ff", 
]
u10m_abs_colormap = matplotlib.colors.ListedColormap(u10m_colors)

u10m_abs_levels = [ 0, 5, 10, 15, 20, 25, 30 ]
u10m_abs_norm=matplotlib.colors.BoundaryNorm(u10m_abs_levels,7)
u10m_abs_colormap.set_over(u10m_colors[6])

u300_colors = [
    "#C0C0C0", 
    "#04e9e7",  # 0.01 - 0.10 inches
    "#02fd02",  # 0.50 - 0.75 inches
    "#fdf802",  # 1.50 - 2.00 inches
    "#fd0000",  # 3.00 - 4.00 inches
    "#bc0000",  # 5.00 - 6.00 inches
    "#ff00ff", 
]
u300_abs_colormap = matplotlib.colors.ListedColormap(u300_colors)

u300_abs_levels = [ 0, 20, 40, 60, 80, 100, 120 ]
u300_abs_norm=matplotlib.colors.BoundaryNorm(u300_abs_levels,7)
u300_abs_colormap.set_over(u10m_colors[6])


vor_colors = [
    "#000066", 
    "#0000cc", 
    "#0000ff", 
    "#0066ff",  
    "#3399ff",  
    "#66ccff",  

    "#ffffff", 
    "#ffffff", 

    "#ffff99", 
    "#ffcc66", 
    "#ff9933", 
    "#ff3300",  
    "#ff0000",  
    "#800000",  
]
vor_colormap = matplotlib.colors.ListedColormap(vor_colors[1:-1])
vor_colormap.set_over(vor_colors[-1])
vor_colormap.set_under(vor_colors[0])

vor_levels = np.arange(-12,14,2)
vor_norm=matplotlib.colors.BoundaryNorm(vor_levels, len(vor_levels))


def makemap(ax,lonl,lonr,latl,latr,small=False) :
# Lambert Conformal Conic map.
  m = Basemap(ax=ax,llcrnrlon=lonl,llcrnrlat=latl,urcrnrlon=lonr,urcrnrlat=latr,
            projection='merc',lat_0=0.5*(latl+latr),lon_0=0.5*(lonl+lonr),
            lat_ts=0.5*(latl+latr),
            rsphere=(6378137.00,6356752.3142),
            resolution ='l')

# draw coastlines, meridians and parallels.
  m.drawcoastlines()
  m.drawcountries()
  m.drawmapboundary()
#  m.drawrivers()

  if (small==True):
    m.readshapefile('/data9/amemiya/PREVENIR/util/shapefiles/provincias_geog',name='provincia')
    m.drawparallels(np.arange(-50,-20,2),labels=[1,1,0,0])
    m.drawmeridians(np.arange(-80,-40,2),labels=[0,0,0,1])
  else:
    m.drawparallels(np.arange(-80,0,10),labels=[1,1,0,0])
    m.drawmeridians(np.arange(-180,180,10),labels=[0,0,0,1])

  return m 

