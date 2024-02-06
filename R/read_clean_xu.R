#' Title
#'
#' @param file "data/rasters/Xu/test10a_cd_ab_pred_corr_2000_2019_v2.tif"
#' @param esa SpatRaster for ESA dataset to be used as template for extent and projection
#'
#' @return SpatRaster object
#' 
read_clean_xu <- function(file, esa) {
  # Xu
  xu_agb_2010 <-
    terra::rast(file, win = ext(esa), snap = "out")[[10]] * 2.2 #conversion from MgC/ha to Mg/ha
  units(xu_agb_2010) <- "Mg/ha"
  names(xu_agb_2010) <- "Xu et al."
  varnames(xu_agb_2010) <- "AGB"
  
  # Project and crop to AZ
  az_sf <- 
    maps::map("state", "arizona", plot = FALSE, fill = TRUE) |> 
    st_as_sf() |> 
    st_transform(st_crs(esa))
  
  project_to_esa(xu_agb_2010, esa) |> 
    crop(az_sf, mask = TRUE)
}