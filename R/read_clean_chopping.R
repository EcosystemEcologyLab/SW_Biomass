#' Title
#'
#' @param path "data/rasters/Chopping/MISR_agb_estimates_20002021.tif"
#'
#' @return SpatRaster object
#' 
read_clean_chopping <- function(path) {
  chopping_agb_2010 <- terra::rast(path)[[10]]
  units(chopping_agb_2010) <- "Mg/ha"
  varnames(chopping_agb_2010) <- "AGB"
  #return:
  chopping_agb_2010
}