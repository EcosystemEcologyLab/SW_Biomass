library(terra)
library(ncdf4)
library(fs)
library(purrr)
# Open Liu AGBc netCDF file
file <- "data/rasters/Liu/Aboveground_Carbon_1993_2012.nc"
liu.nc <- nc_open(file)

# Extract lat/lon attributes
lat <- ncvar_get(liu.nc, 'latitude')
lon <- ncvar_get(liu.nc, 'longitude')

# Extract AGBc variable (matrix)
liu.agb.mat <- ncvar_get(liu.nc, 'Aboveground Biomass Carbon')

# Close netCDF file
nc_close(liu.nc)

# Get spatial extent of Liu dataset
liu.ext <- c(min(lon), max(lon), min(lat), max(lat))

# Set spatial coordinate reference system variable
liu.crs <- '+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'

# Create initial rasterized matrix
initial.ras <- terra::rast(liu.agb.mat[,,1])
terra::ext(initial.ras) <- liu.ext
terra::crs(initial.ras) <- liu.crs

# Set output raster stack for all subsequent years/matrix layers
rast_global <- rast(initial.ras)

for (i in 2 : dim(liu.agb.mat)[3]){
  ras <- terra::rast(liu.agb.mat[,,i])
  terra::ext(ras) <- liu.ext
  terra::crs(ras) <- liu.crs
  rast_global <- c(ras, rast_global)
}

# Set names for raster stack (years 1993 to 2012)
names(rast_global) <- as.character(seq(1993,2012,1))

get_file_sizes <- function(rast) {
  map(1:nlyr(rast), \(x) 1:x) |> 
    map(\(x) rast[[x]]) |> 
    map(\(x) {
      path <- fs::path_temp(glue::glue("file_{nlyr(x)}lyr.nc"))
      terra::writeCDF(x, path, overwrite = TRUE)
      path
    }) |> 
    map(fs::file_size) |>
    list_c()
}

file_sizes_global <- get_file_sizes(rast_global)
plot(1:20, file_sizes_global)
nyrs <- 1:20
m <- lm(file_sizes_global ~ nyrs)
coef(m) |> fs::as_fs_bytes()

#what about just CONUS
conus <-
  vect("data/shapefiles/CONUS_ARD_grid") |> 
  project(crs(rast_global))

rast_conus <- crop(rast_global, conus, mask = TRUE)
file_sizes_conus <- get_file_sizes(rast_conus)
file_sizes_conus
m <- lm(file_sizes_conus ~ nyrs)
coef(m) |> fs::as_fs_bytes()

#just arizona
targets::tar_load("az")
rast_az <- rast_conus |> 
  crop(az, mask = TRUE)
# project to 30m res
x <- rast(res = c(0.03, 0.03), crs = crs(rast_az), ext = ext(rast_az))

rast_az_30m <- project(rast_az, x)

get_file_sizes(rast_az)
get_file_sizes(rast_az_30m)

#just pima
targets::tar_load("pima")
rast_pima <- rast_conus |> 
  crop(pima, mask = TRUE)
# project to 30m res
x <- rast(res = c(0.001, 0.001), crs = crs(rast_pima), ext = ext(rast_pima))

rast_pima_1m <- project(rast_pima, x)

get_file_sizes(rast_pima)
get_file_sizes(rast_pima_1m)
