library(targets)
library(terra)
library(tidyverse)
library(sf)

tar_load(agb_stack)

# values(agb_stack[[1]]) |> mean(na.rm = TRUE) #faster, not exactly the same value though
#TODO check that raster is masked to AZ.  if not, do this in project_to_esa maybe?

agb_df <- 
  as.data.frame(agb_stack) |> 
  as_tibble() |> #TODO slice here instead.  Pivot will be faster, pixels will be the same across all datasets
  tidyr::pivot_longer(everything(), values_to = "AGB", names_to = "dataset") 

agb_df |> 
  dplyr::slice_sample(n = 5000, by = dataset) |> 
  ggplot(aes(x = dataset, y = AGB)) +
  geom_violin(draw_quantiles = c(0.25, 0.5, 0.75), scale = "width") +
  labs(title = "Sample (n = 5000) of AGB raster data for AZ") +
  scale_x_discrete(labels = \(x) str_remove(x, "_agb_2010"))
