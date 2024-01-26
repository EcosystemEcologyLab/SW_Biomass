#' Title
#'
#' @param dir "data/rasters/ESA_CCI/"
#' @param sw_box_file "data/shapefiles/SW_Region_Box.shp"
#'
#' @return SpatRaster object
#' 
read_clean_esa <- function(dir, sw_box_file) {
  sw_box <- terra::vect(sw_box_file)
  esa_agb_2010 <- 
    dir |>
    dir_ls(glob = "*.tif") |> 
    purrr::map(function(x) {
      #snap = "near" is the default for crop().  Other datsets use snap = "out" to get extra pixels so data isn't lost when projecting to be the same resolution and extent as this one.
      terra::rast(x, win = ext(sw_box), snap = "near") 
    }) |> 
    terra::sprc() |> 
    terra::merge()
    
  units(esa_agb_2010) <- "Mg/ha"
  names(esa_agb_2010) <- "esa_agb_2010"
  varnames(esa_agb_2010) <- "AGB"
  
  #return
  esa_agb_2010
}
