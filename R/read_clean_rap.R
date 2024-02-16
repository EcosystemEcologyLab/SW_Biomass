#' Title
#' 
#' README: http://rangeland.ntsg.umt.edu/data/rap/rap-vegetation-biomass/v3/README
#'
#' @param file "data/rasters/RAP/vegetation-biomass-v3-2010.tif"
#' @param esa SpatRaster for ESA dataset to be used as template for extent and projection
#'
#' @return SpatRaster object with two layers
read_clean_rap <- function(file, esa) {
  rap_agb_2010 <-
    terra::rast(file, win = ext(esa), snap = "out")
  #or, download just SW directly from web
  # rap_agb_2010 <- rast("http://rangeland.ntsg.umt.edu/data/rap/rap-vegetation-biomass/v3/vegetation-biomass-v3-2020.tif", win = ext(sw_box), snap = "out", vsi = TRUE)
  
  #convert units from lb/acre to Mg/ha
  conv_factor <-
    units::set_units(1, "lb/acre") |> units::set_units("Mg/ha") |> as.numeric()
  rap_agb_2010 <- rap_agb_2010 * conv_factor #not sure how to speed this up.
  varnames(rap_agb_2010) <- "AGB"
  names(rap_agb_2010) <- c("RAP annuals", "RAP perrenials")
  units(rap_agb_2010) <- c("Mg/ha", "Mg/ha")
  
  # Project and crop 
  project_crop_esa(rap_agb_2010, esa)
}