summarize_agb <- function(raster, sub_vect) {
  raster_name <- deparse(substitute(raster))
  sub_vect_name <- deparse(substitute(sub_vect))
  #project vector to same CRS as raster and convert to sf
  sub_vect <- terra::project(sub_vect, raster) |> sf::st_as_sf()
  
  exactextractr::exact_extract(
    raster, sub_vect, fun = c(
      "count",
      "min",
      "max",
      "mean",
      "stdev",
      "median",
      "quantile",
      "sum"
    ),
    quantiles = c(0.025, 0.1, 0.25, 0.75, 0.9, 0.975)
  ) |> 
    pivot_longer(cols = everything(), names_to = c("stat", "year"), names_sep = "\\.") |>
    pivot_wider(names_from = "stat", values_from = "value") |> 
    rename(q02.5 = q02, q97.5 = q97) |> 
    mutate(product = raster_name, subset = sub_vect_name, .before = year)
}