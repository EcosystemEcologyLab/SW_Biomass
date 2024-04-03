make_agb_stack <- function(..., region) {
  stack <- c(...)
  region <- st_transform(region, st_crs(stack))
  stack |> crop(region, overwrite = TRUE) |> mask(vect(region))
}
