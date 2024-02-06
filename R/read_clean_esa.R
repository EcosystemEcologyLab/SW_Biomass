#' Title
#'
#' @param dir "data/rasters/ESA_CCI/"
#' @param az_sf MULTIPOLYGON simple feature for state of arizona
#'
#' @return SpatRaster object
#' 
read_clean_esa <- function(dir, az_sf) {
  esa_agb_2010 <- 
    dir |>
    dir_ls(glob = "*.tif") |> 
    purrr::map(terra::rast) |> 
    terra::sprc() |> 
    terra::mosaic() # mosaic() is much faster than merge() apparently
    
  units(esa_agb_2010) <- "Mg/ha"
  names(esa_agb_2010) <- "ESA CCI"
  varnames(esa_agb_2010) <- "AGB"
  
  #return
  esa_agb_az
}
