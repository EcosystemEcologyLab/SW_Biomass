#' Projects datasets to same extent and resolution as ESA.
#'
#' @param rast SpatRaster of interest
#' @param esa the SpatRaster for the ESA dataset, as a template
#'
#' @return SpatRaster
project_to_esa <- function(rast, esa) {
  project(rast, esa,
          method = "bilinear", #this is the default, other options might be better
          threads = 4) 
}
