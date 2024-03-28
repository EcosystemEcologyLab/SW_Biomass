library(targets)
tar_load_globals()
tar_load(agb_stack)
tar_load(az)

agb_scaled_az <- agb_stack |> crop(az, mask = TRUE) |> scale()
ggplot() +
  geom_spatraster(data = agb_scaled_az) + 
  facet_wrap(~lyr)

agb_scaled_sd_az <- agb_scaled_az |>  stdev(na.rm = TRUE)

p_base <- ggplot() +
  geom_spatraster(data = agb_scaled_sd_az)

p_base + scale_fill_viridis_c()

p_base +
  scale_fill_viridis_c(
    option = "viridis",
    trans = "log10",
    breaks = scales::breaks_log(5),
    na.value = "transparent",
    guide = guide_colorbar(barwidth = 0.6, title.position = "top")
  )
