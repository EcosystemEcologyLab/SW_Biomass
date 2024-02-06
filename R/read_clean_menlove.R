#' Read and clean Menlove & Healey product
#' 
#' This uses just the live + dead layer for now
#'
#' @param dir data/rasters/Menlove/data/
#' @param esa SpatRaster for ESA dataset to be used as template for extent and projection
#'
#' @return a SpatRaster object
read_clean_menlove <- function(dir, esa) {
  menlove_sf <- sf::read_sf(dir)
  #extract just the CRM_LIVE_D layer for live + dead trees
  #TODO ask if there is interest in these separated
  menlove_agb_sf <- menlove_sf["CRM_LIVE_D"]
  
  #transform to common CRS and crop to AZ
  az_sf <- 
    maps::map("state", "arizona", plot = FALSE, fill = TRUE) |> 
    st_as_sf() |> 
    st_transform(st_crs(esa))
  
  menlove_az_sf <-
    menlove_agb_sf |> 
    st_transform(st_crs(esa)) |> 
    st_intersection(az_sf) |> 
    select(-ID)
  
  #rasterize
  template <- 
    stars::st_as_stars(sf::st_bbox(esa), dx = res(esa)[1], dy = res(esa)[2], values = NA_real_)
  menlove_stars <- st_rasterize(menlove_az_sf, template)
  
  #convert to SpatRaster and add names and units
  menlove_rast <- terra::rast(menlove_stars)
  units(menlove_rast) <- "Mg/ha"
  varnames(menlove_rast) <- "AGB"
  names(menlove_rast) <- "Menlove & Healey"
  
  #return
  menlove_rast
}