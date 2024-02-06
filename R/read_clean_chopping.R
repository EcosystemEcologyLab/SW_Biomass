#' Read and wrangle data from Chopping et al. 2022
#'
#' @param file "data/rasters/Chopping/MISR_agb_estimates_20002021.tif"
#' @param esa SpatRaster for ESA dataset to be used as template for extent and projection
#' 
#' @references Chopping, M.J., Z. Wang, C. Schaaf, M.A. Bull, and R.R. Duchesne.
#'   2022. Forest Aboveground Biomass for the Southwestern U.S. from MISR,
#'   2000-2021. ORNL DAAC, Oak Ridge, Tennessee, USA.
#'   https://doi.org/10.3334/ORNLDAAC/1978
#' 
#' @return SpatRaster object
#' 
read_clean_chopping <- function(file, esa) {
  # Read in file and select
  # Spans 2000 - 2021 so layer 10 is 2010
  chopping_agb_2010 <- terra::rast(file, lyrs = 10)
  
  # Set units and names
  units(chopping_agb_2010) <- "Mg/ha"
  names(chopping_agb_2010) <- "Chopping et al."
  varnames(chopping_agb_2010) <- "AGB"

  # Project and crop
  az_sf <- 
    maps::map("state", "arizona", plot = FALSE, fill = TRUE) |> 
    st_as_sf() |> 
    st_transform(st_crs(esa))
  
  project_to_esa(chopping_agb_2010, esa) |> 
    crop(az_sf, mask = TRUE)
}