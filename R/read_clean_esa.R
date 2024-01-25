#' Title
#'
#' @param files vector of file paths to adjacent .tif tiles
#' @param sw_box SpatVector object for southwest
#'
#' @return SpatRaster object
#' 
read_clean_esa <- function(files, sw_box) {
  esa_agb_2010 <- 
    files |>
    purrr::map(function(x) {
      terra::rast(x, win = ext(sw_box), snap = "out")
    }) |> 
    terra::sprc() |> 
    terra::merge()
    
  units(esa_agb_2010) <- "Mg/ha"
  names(esa_agb_2010) <- varnames(esa_agb_2010) <- "AGB"
  
  #return
  esa_agb_2010
}
