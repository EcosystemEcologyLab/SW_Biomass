project_to_esa <- function(raster, esa_agb) {
  rast_name <- deparse(substitute(raster))
  
  #if more than one layer, just get 2010
  if (length(names(raster)) > 1) {
    if (!"2010" %in% names(raster)) {
      stop("Product doesn't have a layer for 2010")
    } else {
      raster <- raster[["2010"]]
    }
  }
  
  # if product is esa_agb, don't do the projection
  if (rast_name != "esa_agb") {
    # use "near" method for low res Liu et al. product to avoid artifacts
    # TODO consider using "near" method for all products for consistency?
    method <- ifelse(rast_name == "liu_agb", "near", "bilinear")
    raster_out <- terra::project(raster, esa_agb, method = method, threads = 4)
  } else {
    raster_out <- raster
  }
  #set layer name to product nickname
  names(raster_out) <- rast_name
  #return:
  raster_out
}