#' Read and wrangle GEDI L4B v2.1 data product
#'
#' README: https://daac.ornl.gov/GEDI/guides/GEDI_L4B_Gridded_Biomass_V2_1.html
#' 
#' @param file
#'   "data/rasters/GEDI_L4B_v2.1/data/GEDI04_B_MW019MW223_02_002_02_R01000M_MU.tif".
#'   This file has values for mean AGB in Mg/ha
#' @param esa SpatRaster for ESA dataset to be used as template for extent and projection
#' @param az_sf MULTIPOLYGON simple feature for state of arizona
#'
#' @return a SpatRaster object
#' 
read_clean_gedi <- function(file, esa, region) {
  #Read in file
  gedi_agb <- terra::rast(file)
  
  # Set units and names
  units(gedi_agb) <- "Mg/ha"
  varnames(gedi_agb) <- "AGB"
  names(gedi_agb) <- "GEDI L4B"
  
  # Project and crop
  project_crop_esa(gedi_agb, esa, region)
}