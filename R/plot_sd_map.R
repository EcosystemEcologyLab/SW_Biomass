#' Title
#'
#' @param agb_stack agb_stack target
#' @param save_path file path to save plot to
#' @param ... other arguments passed to ggsave(), e.g. height and width
#'
#' @return nothing, called for side effects of saving a plot
#'
#' @examples
#' plot_sd_map(agb_stack, width = 7, height = 6)
plot_sd_map <- function(agb_stack, save_path = "docs/fig/sd_map.png", ...) {
  az_border_sf <- 
    maps::map("state", "arizona", plot = FALSE, fill = TRUE) |> 
    st_as_sf() |> 
    st_transform(crs(agb_stack))
  
  agb_sd_az <- agb_stack |> 
    crop(az_border_sf, mask = TRUE) |>  #can't crop more than 4 layers at once. might want to move this into read_wrangle functions
    stdev(na.rm = TRUE)
  
  p <- ggplot() +
    tidyterra::geom_spatraster(data = agb_sd_az) +
    geom_sf(data = az_border_sf, fill = NA) +
    scale_fill_viridis_c(option = "D", na.value = "transparent") +
    coord_sf() +
    labs(fill = "AGB standard deviation (Mg/ha)") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  ggsave(save_path, p, ...)
}