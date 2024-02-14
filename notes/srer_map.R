library(targets)
library(patchwork)
tar_load_globals()
tar_load(agb_stack)
tar_load(srer_dir)

az_border_sf <- 
  maps::map("state", "arizona", plot = FALSE, fill = TRUE) |> 
  st_as_sf() |> 
  st_transform(crs(agb_stack))

agb_sd <- agb_stack |> 
  stdev(na.rm = TRUE)
p_base <-  ggplot() +
  tidyterra::geom_spatraster(
    data = agb_sd,
    # maxcell = length(values(agb_sd)) # uncomment for "production"
  )
p_full <-  ggplot() +
  tidyterra::geom_spatraster(
    data = agb_sd,
    maxcell = length(values(agb_sd)) # uncomment for "production"
  )
p <-
  p_base +
  geom_sf(data = az_border_sf, fill = NA, color = "black") +
  geom_sf(data = st_as_sfc(srer_bbox), fill = NA, color = "red") +
  # TODO: make the high SD areas "pop" more
  scale_fill_viridis_c(
    option = "viridis",
    na.value = "transparent",
    guide = guide_colorbar(barwidth = 5, barheight = 0.5, label.position = "top", title.position = "left")
  ) +
  coord_sf(expand = FALSE) +
  theme_minimal(base_size = 9) +
  # labs(fill = "SD AGB (Mg ha<sup>-1</sup>)") +
  theme(
    legend.title = element_blank(),
    # legend.title = element_markdown(),
    legend.position = "top",
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.box.spacing = unit(0, "pt")
  ) 
p
ggsave("test.png", p,bg = "white", height =2)

# SRER cutout -------------------------------------------------------------

srer_vect <-
  vect(srer_dir) |> 
  project(agb_sd)

srer_sd <-
  agb_sd |> 
  crop(srer_vect)

#TODO draw box for SRER bbox + buffer on main plot
srer_bbox <- st_bbox(srer_vect)

# As inset map ------------------------------------------------------------


p_srer <-
  ggplot() +
  tidyterra::geom_spatraster(data = srer_sd) +
  geom_sf(data = srer_vect, fill = NA, color = "black") +
  scale_fill_viridis_c(
    option = "viridis",
    na.value = "transparent",
    guide = guide_colorbar(
      barwidth = 0.5,
      barheight = 4,
      label.position  = "left"
      # barwidth = 3,
      # barheight = 0.5,
      # label.position = "top",
      # direction = "horizontal"
    )
  ) +
  labs(fill = "") +
  coord_sf(expand = FALSE) +
  theme_minimal(base_size = 9) +
  theme(
    legend.title = element_blank(),
    legend.position = "left",
    # legend.position = "top",
    axis.text = element_blank(),
    panel.border = element_rect(fill = NA),
    # plot.background = element_rect(fill = "grey")
  )
p_srer
(p + scale_y_continuous(expand = expansion(mult = c(0.3, 0.1)))) +
  inset_element(
    p_srer,
    left = 0.05, bottom = 0, right = 0.4, top = 0.4, align_to = "full"
  )
# ggsave("test.png", height = 2)
# no chance of this looking good, right?


# two-panel ---------------------------------------------------------------
p_srer <- ggplot() +
  tidyterra::geom_spatraster(data = srer_sd) +
  geom_sf(data = srer_vect, fill = NA, color = "white") +
  geom_sf(data = st_as_sfc(srer_bbox), fill = NA, color = "red") +
  # TODO: make the high SD areas "pop" more
  scale_fill_viridis_c(
    option = "viridis",
    na.value = "transparent",
    guide = guide_colorbar(barwidth = 5, barheight = 0.5, label.position = "top", direction = "horizontal")
  ) +
  coord_sf(expand = FALSE) +
  theme_minimal(base_size = 9) +
  theme(
    legend.title = element_blank(),
    # legend.title = element_markdown(),
    legend.position = "top",
    # axis.text.x = element_text(angle = 45, hjust = 1),
    legend.box.spacing = unit(0, "pt"),
    axis.text = element_blank()
  ) 


p + p_srer
ggsave('twopanel.png', height = 2, bg = "white")


# Make colors "pop" -------------------------------------------------------

# because of the long tail of high values, the map is mostly purple.  How to make it look better?
map_all <- p_full + scale_fill_viridis_c(na.value = "transparent")
ggsave("map_all.png", map_all, height = 2)

# different color palettes don't really help
map_plasma <- p_full + scale_fill_viridis_c(option = "plasma", na.value = "transparent")
ggsave("map_plasma.png", map_plasma, height = 2)

#use log1p transformation
map_log <- p_full + scale_fill_viridis_c(trans = "log1p", na.value = "transparent")
ggsave("map_log1p.png", map_log, height = 2)

#set bounds and "squish" oob values in
map_squish <-
  p_full +
  scale_fill_viridis_c(
    limits = c(0, 100),
    breaks = c(0, 25, 50, 75, 100),
    labels = c("0", "25", "50", "75", "≥100"),
    na.value = "transparent",
    oob = scales::squish
  )
# map_squish
ggsave("map_squish.png", map_squish, height = 2)
