#' Read Liu .nc file and convert to raster with correct projection and units
#'
#' @param file data/rasters/Liu/Aboveground_Carbon_1993_2012.nc
#' @param esa SpatRaster for ESA dataset to be used as template for extent and projection
#' @return a SpatRaster object
#' 
read_clean_liu = function(file, esa) {

  # Open Liu AGBc netCDF file
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
  out.stack <- rast(initial.ras)
  
  for (i in 2 : dim(liu.agb.mat)[3]){
    ras <- terra::rast(liu.agb.mat[,,i])
    terra::ext(ras) <- liu.ext
    terra::crs(ras) <- liu.crs
    out.stack <- c(ras, out.stack)
  }
  
  # Set names for raster stack (years 1993 to 2012)
  names(out.stack) <- as.character(seq(1993,2012,1))
  
  out_sw <- project_to_esa(out.stack, esa)
  
  # Return output raster stack (multiply by 2.2 to convert from MgC/ha to Mg/ha)
  out_sw <- out_sw * 2.2
  out_2010 <- out_sw[[18]]
  varnames(out_2010) <- "AGB"
  names(out_2010) <- "liu_agb_2010"
  terra::units(out_2010) <-  "Mg/ha"
  
  #return
  out_2010
}
