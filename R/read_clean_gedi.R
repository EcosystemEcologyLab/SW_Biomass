#' Title
#'
#' README: https://daac.ornl.gov/GEDI/guides/GEDI_L4B_Gridded_Biomass_V2_1.html
#' 
#' @param file
#'   "data/rasters/GEDI_L4B_v2.1/data/GEDI04_B_MW019MW223_02_002_02_R01000M_MU.tif".
#'   This file has mean values for AGB in Mg/ha
#' @param esa SpatRaster for ESA dataset to be used as template for extent and projection
#'
#' @return a SpatRaster object
#' 
read_clean_gedi <- function(file, esa, az_sf) {
  #project 
  gedi_agb <- terra::rast(file)
  units(gedi_agb) <- "Mg/ha"
  varnames(gedi_agb) <- "AGB"
  names(gedi_agb) <- "GEDI L4B"
  
  #return:
  project_to_esa(gedi_agb, esa, az_sf)
}
