read_agb <- function(path, win_vect) {

  if (fs::is_file(path)) {
    rast_crs <- terra::crs(terra::rast(path))
    win_vect <-  win_vect |> terra::project(rast_crs)
    
    out <- 
      terra::rast(path, win = terra::ext(win_vect)) |> 
      terra::crop(win_vect)
  }
  if (fs::is_dir(path)) {
    tifs <- fs::dir_ls(path, glob = "*.tif") 
    vrt_crs <- terra::crs(terra::vrt(tifs))
    win_vect <- win_vect |> terra::project(vrt_crs)
  
    out <-
      vrt(tifs, set_names = TRUE) |> 
      crop(win_vect)
  }
  out
}
