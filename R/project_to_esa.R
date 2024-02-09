#' Projects datasets to same extent and resolution as ESA.
#'
#' From the help file for `project()`: "The output resolution should generally be
#' similar to the input resolution, but there is no "correct" resolution in raster
#' transformation. It is not obvious what this resolution is if you are using
#' lon/lat data that spans a large North-South extent."
#'
#' @param rast SpatRaster of interest
#' @param esa the SpatRaster for the ESA dataset, as a template
#'
#' @return SpatRaster
project_to_esa <- function(rast, esa, method = "bilinear") {
  project(rast, esa,
          method = method, #this is the default, other options might be better
          threads = 4)
}
