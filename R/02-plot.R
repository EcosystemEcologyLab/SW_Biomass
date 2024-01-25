library(terra)
library(tidyterra)
library(fs)
library(ggplot2)
library(sf)
library(maps)


# Read in files -----------------------------------------------------------

files <- dir_ls("data/rasters/harmonized/", glob = "*.tiff")
agb_stack <- rast(files)
agb_stack

sw_shps  <- dir_ls("data/shapefiles/", glob = "*.shp")
sw_box   <- vect(sw_shps[3]) #SW region
gw_box   <- vect(sw_shps[1]) #goldwater range
nnss_box <- vect(sw_shps[2]) 
ws_box   <- vect(sw_shps[4]) #white sands

az_border_sf <- 
  maps::map("state", "arizona") |> 
  st_as_sf() 

az_border_vect <- 
  az_border_sf |>
  vect() |>
  project(agb_stack)

ext(az_border_sf)
agb_az <- agb_stack |> crop(ext(az_border_sf))

# Plots -------------------------------------------------------------------

p <- ggplot() +
  geom_spatraster(data = agb_stack) +
  geom_polygon(data = map_data("state", "arizona"), aes(x = long, y = lat), fill = NA, color = "black") +
  scale_fill_viridis_c(option = "D") +
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
