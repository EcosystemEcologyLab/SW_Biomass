#' Title
#'
#' @param file "data/rasters/Xu/test10a_cd_ab_pred_corr_2000_2019_v2.tif"
#' @param sw_box SpatVector of southwest
#'
#' @return SpatRaster object
#' 
read_clean_xu <- function(file, sw_box) {
  # Xu
  xu_agb_2010 <-
    terra::rast(file, win = ext(sw_box), snap = "out")[[10]] * 2.2 #conversion from MgC/ha to Mg/ha
  units(xu_agb_2010) <- "Mg/ha"
  names(xu_agb_2010) <- varnames(xu_agb_2010) <- "AGB"
  
  #return
  xu_agb_2010
}