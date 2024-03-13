library(sf)
library(tidyverse)
library(fuzzyjoin)

#USFS data

usfs <- st_read("data/shapefiles/S_USA.NFSLandUnit/")
forests <- usfs |> 
  filter(NFSLANDU_1 == "National Forest")
grasslands <- usfs |> 
  filter(NFSLANDU_1 == "National Grassland")

forests |> select(NAME = NFSLANDU_2)

ggplot() +
  geom_sf(data = forests[5,])

#NEON

# Field sampling boundaries
neon_field <- st_read("data/shapefiles/Field_Sampling_Boundaries_2020/")
neon_core <- neon_field |> 
  filter(siteType == "Core Terrestrial")
site_ids <- neon_core |> as_tibble() |> select(siteName, siteID)

# Flight boundaries for 2021 (these may change year to year)
neon_flights <-
  st_read("data/shapefiles/AOP_flightBoxes/") |> 
  mutate(siteName = str_remove(siteName, " NEON")) |> 
  filter(siteID %in% core_ids)

# kmz file
#What layers are available?
neon_kml <- "/vsizip/data/shapefiles/NEON_Field_Sites_KMZ_v18_Mar2023.kmz/doc.kml"
st_layers(neon_kml)

# Layer of point locations of towers
neon_towers <- 
  st_read(neon_kml, layer = "NEON Core Terrestrial") |> 
  select(-Description) |> 
  separate(Name, into = c("Domain", "Name"), sep = " - ") |> 
  #need to use fuzzy join because site names differ slightly
  stringdist_left_join(site_ids, by = c(Name = "siteName")) |> 
  # fix manually: Guanica Forest, Yellowstone Northern Range (Frog Rock), Toolik Lake
  mutate(siteID = case_when(
    Name == "Guanica Forest" ~ "GUAN",
    Name == "Yellowstone Northern Range (Frog Rock)" ~ "YELL",
    Name == "Toolik Lake" ~ "TOOL",
    .default = siteID 
  )) |> 
  select(-siteName) |> st_as_sf()
# neon_towers

plot_list <-
  map(site_ids$siteID, \(x) {
    ggplot() +
      geom_sf(data = neon_core |> filter(siteID == x)) +
      geom_sf(data = neon_flights |> filter(siteID == x), fill = "green", alpha = 0.5) +
      geom_sf(data = neon_towers |> filter(siteID == x)) +
      labs(title = x)
  })
patchwork::wrap_plots(plot_list)

ggsave("notes/NEON_data.png", height = 10, width = 10)
