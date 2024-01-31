library(targets)
library(terra)
library(tidyverse)
library(sf)
tar_load(agb_stack)

az_border_vect <- 
  maps::map("state", "arizona", plot = FALSE, fill = TRUE) |> 
  st_as_sf() |>
  st_transform(crs(agb_stack)) |> 
  vect()
az_border_vect

extract(agb_stack[[1]], az_border_vect, fun = mean) #hella slow
values(agb_az[[1]]) |> mean(na.rm = TRUE) #faster, not exactly the same value though

values(agb_az) |> colMeans(na.rm = TRUE)

agb_df <- 
  as.data.frame(agb_az) |> 
  as_tibble() |> 
  tidyr::pivot_longer(everything(), values_to = "AGB", names_to = "dataset") 

agb_df |> 
  dplyr::slice_sample(n = 10000) |> 
  ggplot(aes(x = dataset, y = AGB)) +
  geom_violin(draw_quantiles = c(0.25, 0.5, 0.75), scale = "width")
