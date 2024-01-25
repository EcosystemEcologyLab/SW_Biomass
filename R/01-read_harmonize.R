# Packages and Functions ---------------------------------------------------
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
chopping_agb_2010 <-
  rast("data/rasters/Chopping/MISR_agb_estimates_20002021.tif")[[10]]
names(chopping_agb_2010) <- "chopping_agb_2010"
varnames(chopping_agb_2010) <- "AGB"
units(chopping_agb_2010) <- "Mg/ha"


# Liu
liu_agb <- liu_nc_to_rast("data/rasters/Liu/")
liu_agb_2010 <- liu_agb[[18]]

units(liu_agb_2010) <- "Mg/ha"
names(liu_agb_2010) <- "liu_agb_2010"
varnames(liu_agb_2010) <- "AGB"

# ESA CCI
esa_agb_2010_f1 <- rast("data/rasters/ESA_CCI/N40W110_ESACCI-BIOMASS-L4-AGB-MERGED-100m-2010-fv4.0.tif", win = ext(sw_box), snap = "out")
esa_agb_2010_f2 <- rast("data/rasters/ESA_CCI/N40W120_ESACCI-BIOMASS-L4-AGB-MERGED-100m-2010-fv4.0.tif", win = ext(sw_box), snap = "out") 
#Combine tiles
esa_agb_2010 <- merge(esa_agb_2010_f1, esa_agb_2010_f2)
# ext(esa_agb_2010_f1)
# ext(esa_agb_2010_f2)
# ext(esa_agb_2010)

units(esa_agb_2010) <- "Mg/ha"
names(esa_agb_2010) <- "esa_agb_2010"
varnames(esa_agb_2010) <- "AGB"

# Xu
xu_agb_2010 <-
  rast(
    "data/rasters/Xu/test10a_cd_ab_pred_corr_2000_2019_v2.tif",
    win = ext(sw_box),
    snap = "out"
  )[[10]] * 2.2 #conversion from MgC/ha to Mg/ha

units(xu_agb_2010) <- "Mg/ha"
names(xu_agb_2010) <- "xu_agb_2010"
varnames(xu_agb_2010) <- "AGB"

#RAP
#README: http://rangeland.ntsg.umt.edu/data/rap/rap-vegetation-biomass/v3/README
rap_agb_2010 <-
  rast(
    "data/rasters/RAP/vegetation-biomass-v3-2010.tif",
    win = ext(sw_box),
    snap = "out"
  )
#or, download just SW directly from web
# rap_agb_2010 <- rast("http://rangeland.ntsg.umt.edu/data/rap/rap-vegetation-biomass/v3/vegetation-biomass-v3-2020.tif", win = ext(sw_box), snap = "out", vsi = TRUE)

#convert units from lb/acre to Mg/ha
conv_factor <-
  units::set_units(1, "lb/acre") |> units::set_units("Mg/ha") |> as.numeric()
rap_agb_2010 <- rap_agb_2010 * conv_factor #not sure how to speed this up.
varnames(rap_agb_2010) <- "AGB"
names(rap_agb_2010) <- c("rap_agb_2010_annual", "rap_agb_2010_perennial")
units(rap_agb_2010) <- c("Mg/ha", "Mg/ha")


# Check CRS ---------------------------------------------------------------

crs(chopping_agb_2010, proj = TRUE); res(chopping_agb_2010)
crs(liu_agb_2010, proj = TRUE); res(liu_agb_2010) #0.25
crs(esa_agb_2010, proj = TRUE); res(esa_agb_2010_f1) #use as "template"
crs(xu_agb_2010, proj = TRUE); res(xu_agb_2010)
crs(rap_agb_2010, proj = TRUE); res(rap_agb_2010) #smallest resolution

#crop first, then project ----------
sw_esa_agb_2010 <- crop(esa_agb_2010, sw_box)

# re-project everything to match ESA

# from the hlep file for `project()`: "The output resolution should generally be
# similar to the input resolution, but there is no "correct" resolution in raster
# transformation. It is not obvious what this resolution is if you are using
# lon/lat data that spans a large North-South extent."

sw_chopping_agb_2010 <- 
  project(chopping_agb_2010, sw_esa_agb_2010,
          method = "bilinear", #this is the default, other options might be better
          threads = 4)
# plot(sw_chopping_agb_2010)

sw_liu_agb_2010 <- 
  project(liu_agb_2010, sw_esa_agb_2010,
          method = "bilinear", #this is the default, other options might be better
          threads = 4)
# plot(sw_liu_agb_2010)

sw_xu_agb_2010 <- 
  project(xu_agb_2010, sw_esa_agb_2010,
          method = "bilinear",
          threads = 4)
# plot(sw_xu_agb_2010)

sw_rap_agb_2010 <- 
  project(rap_agb_2010, sw_esa_agb_2010,
          method = "bilinear",
          threads = 4)

sw_rap_annual_2010 <- sw_rap_agb_2010[[1]]
sw_rap_perennial_2010 <- sw_rap_agb_2010[[2]]

# plot(sw_rap_annual_2010)
# plot(sw_rap_perennial_2010)


# Write geotiffs ----------------------------------------------------------

writeRaster(sw_chopping_agb_2010, "data/rasters/harmonized/chopping.tiff", overwrite = TRUE)
writeRaster(sw_liu_agb_2010, "data/rasters/harmonized/liu.tiff", overwrite = TRUE)
writeRaster(sw_xu_agb_2010, "data/rasters/harmonized/xu.tiff", overwrite = TRUE)
writeRaster(sw_rap_agb_2010, "data/rasters/harmonized/rap.tiff", overwrite = TRUE)
writeRaster(sw_esa_agb_2010, "data/rasters/harmonized/esa.tiff", overwrite = TRUE)

