srer_vect <-
  vect(srer_dir) |> 
  project(agb_sd)

srer_sd <-
  agb_sd |> 
  crop(srer_vect)


#TODO draw box for SRER bbox + buffer on main plot
p_srer <-
  ggplot() +
  tidyterra::geom_spatraster(data = srer_sd) +
  geom_sf(data = srer_vect, fill = NA, color = "black") +
  scale_fill_viridis_c(
    option = "viridis",
    na.value = "transparent",
    guide = guide_colorbar(barwidth = 0.6, title.position = "top")
  ) +
  labs(fill = "SD AGB (Mg ha<sup>-1</sup>)") +
  coord_sf() +
  theme_minimal(base_size = 9) +
  theme(legend.title = element_markdown())
# p_srer
