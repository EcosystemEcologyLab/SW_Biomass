#' Title
#'
#' @param dir data/rasters/LT_GNN/
#' @param esa SpatRaster for ESA dataset to be used as template for extent and projection
#'
#' @return a SpatRaster object
#' 
read_clean_lt_gnn <- function(dir, esa) {

  zips <- fs::dir_ls(dir, glob = "*.zip")
  tifs <- 
    zips |> 
    fs::path_file() |>
    fs::path_ext_set(".tif")
  
  rast_paths <- fs::path("/vsizip", zips, tifs)
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
    terra::mosaic() #slow step
  
  #TODO source metadata states scale factor = 10.  What does that mean? Do I
  #need to divide/multiply by 10? The values seem reasonable as they are.
  
  varnames(tiles_combined) <- "AGB"
  names(tiles_combined) <- c("LT-GNN")
  units(tiles_combined) <- c("Mg/ha")

  # Project and crop to AZ
  az_sf <- 
    maps::map("state", "arizona", plot = FALSE, fill = TRUE) |> 
    st_as_sf() |> 
    st_transform(st_crs(esa))
  
  project_to_esa(tiles_combined, esa) |> 
    crop(az_sf, mask = TRUE)
}
