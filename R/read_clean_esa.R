#' Title
#'
#' @param dir "data/rasters/ESA_CCI/"
#'
#' @return SpatRaster object
#' 
read_clean_esa <- function(dir) {
  # read in tiles and combine
  esa_agb_2010 <- 
    dir |>
    dir_ls(glob = "*.tif*") |> 
    purrr::map(terra::rast) |> 
    terra::sprc() |> 
    terra::mosaic() # mosaic() is much faster than merge() apparently
  
  # set units and names  
  units(esa_agb_2010) <- "Mg/ha"
  names(esa_agb_2010) <- "ESA CCI"
  varnames(esa_agb_2010) <- "AGB"
  
  # Crop to AZ + CA
  ca_az_sf <- 
    maps::map("state", c("arizona", "california"), plot = FALSE, fill = TRUE) |> 
    st_as_sf() |> 
    st_transform(st_crs(esa_agb_2010))
  
  #TODO should mask be FALSE and masking happen later just before calculations?
  esa_agb_2010 |> 
    crop(ca_az_sf, mask = TRUE)
}
