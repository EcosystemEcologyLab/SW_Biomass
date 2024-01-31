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
  
  #TODO source metadata states scale factor = 10.  What does that mean? Do I need to divide/multiply by 10?
  
  varnames(tiles_combined) <- "AGB"
  names(tiles_combined) <- c("lt_gnn_agb_2010")
  units(tiles_combined) <- c("Mg/ha")

  #Return
  project_to_esa(tiles_combined, esa)
}