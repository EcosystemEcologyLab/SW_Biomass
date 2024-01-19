#' Read Liu .nc file and convert to raster with correct projection and units
#'
#' @param path the file path to the directory containing Liu .nc files
#'
#' @return a SpatRaster object
#' 
liu_nc_to_rast = function(path) {
library(ncdf4)
  
  # Open Liu AGBc netCDF file
  liu.nc <- nc_open(list.files(path, pattern = '.nc', full.names = TRUE))
  
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
  out.stack <- rast(initial.ras)
  
  for (i in 2 : dim(liu.agb.mat)[3]){
    ras <- terra::rast(liu.agb.mat[,,i])
    terra::ext(ras) <- liu.ext
    terra::crs(ras) <- liu.crs
    out.stack <- c(ras, out.stack)
  }
  
  # Set names for raster stack (years 1993 to 2012)
  names(out.stack) <- as.character(seq(1993,2012,1))
  
  # Return output raster stack (multiply by 2.2 to convert from MgC/ha to Mg/ha)
  out.stack * 2.2
}