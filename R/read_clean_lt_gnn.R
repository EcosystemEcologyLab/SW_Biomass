#' Title
#'
#' @param files vector of paths to .zip files in data/rasters/LT_GNN/
#' @param esa SpatRaster for ESA dataset to be used as template for projection
#' @param region sf object used to crop and mask raster
#' @return a SpatRaster object
#' 
read_clean_lt_gnn <- function(files, esa, region) {
  
  tifs <- 
    files |> 
    fs::path_file() |>
    fs::path_ext_set(".tif")
  
  rast_paths <- fs::path("/vsizip", files, tifs)
  #read in a sample to get extent and projection
  samp <- rast(rast_paths[1])
  #transform ext of esa to ext of sample
  sw_ext <- project(ext(esa), from = crs(esa), to = crs(samp))
  
  tiles_sprc <-
    rast_paths |> 
    # Each tile has 27 layers, one for each year from 1990:2017; layer 21 is year 2010
    purrr::map(\(x) rast(x, lyrs = 21, win = sw_ext, snap = "out")) |>  
    terra::sprc() 
  
  tiles_combined <- 
    tiles_sprc |> 
    terra::merge() #slow step
  #I did some benchmarking and of vrt(), merge(), and mosaic(), merge() is the fastest.
  
  varnames(tiles_combined) <- "AGB"
  names(tiles_combined) <- c("LT-GNN")
  units(tiles_combined) <- c("Mg/ha")

  # Project and crop
  project_crop_esa(tiles_combined, esa, region)
}
