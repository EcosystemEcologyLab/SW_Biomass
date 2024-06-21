summarize_agb <- function(raster, sub_vect) {
  raster_name <- deparse(substitute(raster))
  sub_vect_name <- deparse(substitute(sub_vect))
  sub_vect <- terra::project(sub_vect, raster)
  raster <- terra::mask(raster, sub_vect)
  
  as.data.frame(raster, na.rm = TRUE) |>
    pivot_longer(everything(), names_to = "year", values_to = "agb") |> 
    dplyr::summarize(
        n = n(),
        mean = mean(agb),
        sd = sd(agb),
        min = min(agb),
        max = max(agb),
        median = median(agb),
        q.025 = quantile(agb, 0.025),
        q.1   = quantile(agb, 0.1),
        q.25  = quantile(agb, 0.25),
        q.75  = quantile(agb, 0.75),
        q.9   = quantile(agb, 0.9),
        q.975 = quantile(agb, 0.975),
        .by = c(year)
      ) |> 
  mutate(product = raster_name, subset = sub_vect_name, .before = year)
}