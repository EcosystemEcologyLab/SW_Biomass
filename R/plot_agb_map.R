#' Title
#'
#' @param agb_stack agb_stack target
#' @param save_path file path to save plot to
#' @param ... other arguments passed to ggsave(), e.g. height and width
#'
#' @return nothing, called for side effects of saving a plot
#'
#' @examples
#' plot_agb_map(agb_stack, width = 7, height = 6)
plot_agb_map <- function(agb_stack, save_path = "fig/agb_map.png", ...) {
  az_border_sf <- 
    maps::map("state", "arizona", plot = FALSE, fill = TRUE) |> 
    st_as_sf() |> 
    st_transform(crs(agb_stack))
  
  #TODO move this step into the read_clean functions
  agb_az <- agb_stack |> crop(az_border_sf, mask = TRUE) #can't crop more than 4 layers at once.
  
  p <- ggplot() +
    tidyterra::geom_spatraster(data = agb_az) +
    geom_sf(data = az_border_sf, fill = NA) +
    scale_fill_viridis_c(option = "D", na.value = "transparent") +
    coord_sf() +
    facet_wrap(~lyr) +
    labs(fill = "AGB (Mg/ha)") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  ggsave(save_path, p, ...)
}
