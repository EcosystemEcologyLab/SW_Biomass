# Packages and Functions ---------------------------------------------------
# library(raster)
library(terra)
library(fs)

source('R/Liu_AGB_Raster_Function.R')

# Get shapefiles for spatial subsets ---------------
sw_shps  <- dir_ls("data/shapefiles/", glob = "*.shp")
sw_box   <- vect(sw_shps[3]) #SW region
gw_box   <- vect(sw_shps[1]) #goldwater range
nnss_box <- vect(sw_shps[2]) 
ws_box   <- vect(sw_shps[4]) #white sands

# Read 2010 AGB data products ------------ 

# Chopping
chopping_agb_2010 <- rast("data/rasters/Chopping/MISR_agb_estimates_20002021.tif")[[10]]

# Liu
liu_agb <- liu_nc_to_rast("data/rasters/Liu/")
liu_agb_2010 <- liu_agb[[8]]

# ESA CCI
esa_agb_2010_f1 <- rast("data/rasters/ESA_CCI/N40W110_ESACCI-BIOMASS-L4-AGB-MERGED-100m-2010-fv4.0.tif")
esa_agb_2010_f2 <- rast("data/rasters/ESA_CCI/N40W120_ESACCI-BIOMASS-L4-AGB-MERGED-100m-2010-fv4.0.tif") #fails to allocate memory

# Xu
xu_agb_2010 <- rast("data/rasters/Xu/test10a_cd_ab_pred_corr_2000_2019_v2.tif")[[10]] * 2.2 #conversion from MgC/ha to Mg/ha
