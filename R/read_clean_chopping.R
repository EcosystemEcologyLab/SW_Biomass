#' Title
#'
#' @param file "data/rasters/Chopping/MISR_agb_estimates_20002021.tif"
#' @param esa SpatRaster for ESA dataset to be used as template for extent and projection
#' @return SpatRaster object
#' 
read_clean_chopping <- function(file, esa) {
  chopping_agb_2010 <- terra::rast(file)[[10]]
  units(chopping_agb_2010) <- "Mg/ha"
  names(chopping_agb_2010) <- "Chopping et al."
  varnames(chopping_agb_2010) <- "AGB"

  #return:
  project_to_esa(chopping_agb_2010, esa)
}