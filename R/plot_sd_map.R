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
   #TODO make this "pop".  Ideas:
   # Use SD of 99%ile of the data instead of all the data to remove extreme values?
   # Not sure how I'd calc quantiles---on all data products combined? 
  agb_sd <- agb_stack |> 
    stdev(na.rm = TRUE)
  
  p <-
    ggplot() +
    tidyterra::geom_spatraster(
      data = agb_sd,
      maxcell = length(values(agb_sd)) # uncomment for "production"
    ) +
    geom_sf(data = az_border_sf, fill = NA) +
    # TODO: make the high SD areas "pop" more
    scale_fill_viridis_c(
      option = "viridis",
      na.value = "transparent",
      guide = guide_colorbar(barwidth = 0.6, title.position = "top")
    ) +
    coord_sf() +
    theme_minimal(base_size = 9) +
    labs(fill = "SD AGB (Mg ha<sup>-1</sup>)") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          legend.title = element_markdown())

  ggsave(save_path, p, ...)
  trim_image(save_path)
}