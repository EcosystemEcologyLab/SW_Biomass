library(terra)
library(tidyterra)
library(fs)
library(ggplot2)
library(sf)
library(maps)


# Read in files -----------------------------------------------------------

# files <- dir_ls("data/rasters/harmonized/", glob = "*.tiff")
# agb_stack <- rast(files)
agb_stack


az_border_sf <- 
  maps::map("state", "arizona", plot = FALSE, fill = TRUE) |> 
  st_as_sf() |> 
  st_transform(crs(agb_stack))

agb_az <- agb_stack |> crop(az_border_sf, mask = TRUE)

# Plots -------------------------------------------------------------------

p <- ggplot() +
  geom_spatraster(data = agb_az) +
  geom_sf(data = az_border_sf, fill = NA) +
  scale_fill_viridis_c(option = "D", na.value = "transparent") +
  coord_sf() +
  facet_wrap(~lyr)
p

ggsave("five_datasets.png", p, width = 8, height = 6)
#why not using the full range? Chopping has some really high value pixels.

p_chopping <- ggplot() +
  geom_spatraster(data = agb_stack, aes(fill = chopping_agb_2010)) +
  scale_fill_viridis_c(option = "D") +
  coord_sf()
p_chopping
ggsave("chopping.png", p_chopping, width = 8, height = 7)

p2 <- ggplot() +
  geom_spatraster(data = agb_stack[[c(2,3,4,5,6)]]) +
  geom_polygon(data = map_data("state", "arizona"), aes(x = long, y = lat), fill = NA, color = "black") +
  scale_fill_viridis_c(option = "D") +
  coord_sf() +
  facet_wrap(~lyr)
p2
ggsave("not_chopping.png", p2, width = 8, height = 6)


agb_stack
