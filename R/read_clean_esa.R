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
    purrr::map(function(x) {
      #snap = "near" is the default for crop().  Other datsets use snap = "out" to get extra pixels so data isn't lost when projecting to be the same resolution and extent as this one.
      terra::rast(x, win = ext(az_sf), snap = "near") 
    }) |> 
    terra::sprc() |> 
    terra::mosaic() # mosaic() is much faster apparently
    
  units(esa_agb_2010) <- "Mg/ha"
  names(esa_agb_2010) <- "esa_agb_2010"
  varnames(esa_agb_2010) <- "AGB"
  
  #return
  esa_agb_2010
}
