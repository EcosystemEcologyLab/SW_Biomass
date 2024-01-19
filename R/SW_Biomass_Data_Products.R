
# Packages ----------------------------------------------------------------

library(raster)
library(fs)

# Get shapefiles for spatial subsets ---------------
sw_shps <- dir_ls("data/shapefiles/", glob = "*.shp")
sw_box = shapefile(sw_shps[3]) #SW region
gw_box = shapefile(sw_shps[1]) #goldwater range
nnss_box = shapefile(sw_shps[2]) 
ws_box = shapefile(sw_shps[4]) #white sands

# Read 2010 AGB data products ------------ 

# Chopping
chopping_agb_2010 = stack("data/rasters/Chopping/MISR_agb_estimates_20002021.tif")[[10]]

# Liu
source('R/Liu_AGB_Raster_Function.R')
liu_agb = liu.raster.fun("data/rasters/Liu/")
liu_agb_2010 = liu_agb[[8]]

# ESA CCI
esa_agb_2010_f1 = raster("data/rasters/ESA_CCI/N40W110_ESACCI-BIOMASS-L4-AGB-MERGED-100m-2010-fv4.0.tif")
esa_agb_2010_f2 = raster("data/rasters/ESA_CCI/N40W120_ESACCI-BIOMASS-L4-AGB-MERGED-100m-2010-fv4.0.tif") #fails

# Xu
xu_agb_2010 = stack("data/rasters/Xu/test10a_cd_ab_pred_corr_2000_2019_v2.tif")[[10]] * 2.2 #conversion from MgC/ha to Mg/ha
