#' Title
#'
#' @param files vector of file paths to .tifs starting at "data/rasters/ESA_CCI/"
#'
#' @return SpatRaster object
#' 
read_clean_esa <- function(files, region) {
  # read in tiles and combine
  esa_agb_2010 <- 
    files |> 
    purrr::map(terra::rast) |> 
    terra::sprc() |> 
    terra::mosaic() # mosaic() is much faster than merge() apparently
  
  # set units and names  
  units(esa_agb_2010) <- "Mg/ha"
  names(esa_agb_2010) <- "ESA CCI"
  varnames(esa_agb_2010) <- "AGB"
  
  region <- st_transform(region, st_crs(esa_agb_2010))

  # check if esa_agb_2010 is inside extent of region already and skip cropping
  if (!all(relate(ext(esa_agb_2010), ext(region), "within"))) {
    esa_agb_2010 <- 
      esa_agb_2010 |> 
      crop(region, mask = FALSE, overwrite = TRUE)
    
  }
  esa_agb <- esa_agb_2010 |> mask(region)
  
  #return
  esa_agb
}
