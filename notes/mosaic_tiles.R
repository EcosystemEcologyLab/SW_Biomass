#how to check if i downloaded all the tiles
library(fs)
library(terra)
library(purrr)

zips <- dir_ls("data/rasters/LT_GNN/")

#GDAL has a file handler for zip files that works by prepending /viszip/.  This allows you to read in a file without unzipping first.
x <- rast("/vsizip/data/rasters/LT_GNN/conus_biomass_ARD_tile_h06v10.zip/conus_biomass_ARD_tile_h06v10.tif")
x
# Has 27 layers, one for each year from 1990:2017
(1990:2017)[21]
x[[21]] #just 2010

# we can read in just layer 21 and it's much faster
x_2010 <- 
  rast("/vsizip/data/rasters/LT_GNN/conus_biomass_ARD_tile_h06v10.zip/conus_biomass_ARD_tile_h06v10.tif",
       lyrs = 21)

# range(x_2010)
# range(x[[21]])

# Create paths ------------------------------------------------------------
data_dir <- "data/rasters/LT_GNN/"
zips <- fs::dir_ls(data_dir)
tifs <- 
  zips |> 
  fs::path_file() |>
  fs::path_ext_set(".tif")

rast_paths <- fs::path("/vsizip", zips, tifs)


# read and combine tiles --------------------------------------------

tiles_combined <-
  rast_paths |> 
  purrr::map(\(x) rast(x, lyrs = 21)) |> 
  terra::sprc() |> 
  terra::mosaic()

#another option is a vrt? But I can't seem to figure out how to read in just one layer from each tile
# tiles_virt <- vrt(rast_paths[1:3], set_names = FALSE, options= c("-b", 21))
# tiles_virt

# plot to figure out what's missing ---------------------------------------

plot(tiles_combined)

library(sf)
library(ggplot2)
az_border_sf <- 
  maps::map("state", "arizona", plot = FALSE, fill = TRUE) |> 
  st_as_sf() |> 
  st_transform(crs(tiles_combined))

ggplot() +
  tidyterra::geom_spatraster(data = tiles_combined) +
  geom_sf(data = az_border_sf, fill = NA) 

#what's missing

library(stringr)
library(dplyr)
library(tidyr)
tifs |> 
  str_extract("h\\d{2}v\\d{2}") |> 
  as_tibble() |> 
  mutate(x = str_extract(value, "(?<=h)\\d{2}") |> as.numeric(),
         y = str_extract(value, "(?<=v)\\d{2}") |> as.numeric()) |> 
  ggplot(aes(x,y)) + 
  geom_point() +
  scale_y_reverse()
