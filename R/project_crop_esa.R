#' Projects datasets to same extent and resolution as ESA.
#'
#' From the help file for `project()`: "The output resolution should generally be
#' similar to the input resolution, but there is no "correct" resolution in raster
#' transformation. It is not obvious what this resolution is if you are using
#' lon/lat data that spans a large North-South extent."
#'
#' @param rast SpatRaster of interest
#' @param esa the SpatRaster for the ESA dataset, as a template
#' @param method using "bilinear" as the default method, but for some datasets
#'   (e.g. Liu et al.) it may not be appropriate because the resolution is very
#'   different from the ESA product.
#'
#' @return SpatRaster
project_crop_esa <- function(rast, esa, method = "bilinear") {
  ca_az_sf <- 
    maps::map("state", c("arizona", "california"), plot = FALSE, fill = TRUE) |> 
    st_as_sf() |> 
    st_transform(st_crs(esa))
  
  project(rast, esa,
          method = method,
          threads = 4) |> 
    crop(ca_az_sf, mask = TRUE)

}
