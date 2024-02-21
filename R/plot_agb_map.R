#' Plot map of AGB faceted by data product
#'
#' @note these plots have to be created and saved in one function.  Saving the
#'   ggplot object doesn't work with geom_spatraster
#'   
#' @param agb_stack SpatRaster object with layers for different data products
#' @param subset SpatVector object to crop and mask to
#' @param downsample logical; include all pixels in the dataset or let
#'   geom_spatraster() do it's default downsampling?
#' @param path passed to ggsave()
#' @param filename passed to ggsave().  Include file extension desired for output (e.g. .png or .pdf)
#' @param ... additional arguments passed to ggsave(), e.g. `height`
#' 
#' @return nothing, called for side effects
#'
#' @examples
#' plot_agb_map(agb_stack)
plot_agb_map <- function(agb_stack, subset, downsample = TRUE, path = "docs/fig", filename = "map_agb.png", ...) {

  agb_subset <- crop(agb_stack, subset, mask = TRUE)
  if (isFALSE(downsample)) {
    n <- length(values(agb_subset[[1]]))
    p_base <- ggplot() +
      tidyterra::geom_spatraster(data = agb_subset, maxcell = n)
  } else {
    p_base <- ggplot() +
      tidyterra::geom_spatraster(data = agb_subset)
  }
  
  #subset of colors from the scio package batlow_w palette
  map_cols <- c("#EFB298", "#C39E4B", "#7D8737", "#437153", "#185661", "#0C325D")
  
  p <-
    p_base +
    scale_fill_gradientn(colours = map_cols, na.value = "transparent") +
    facet_wrap(~lyr) +
    labs(fill = "AGB (Mg/ha)") +
    theme_minimal(base_size = 10) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  if (fs::path_ext(filename) %in% c("pdf", "svg", "eps", "ps")) {
    p <- ggrastr::rasterise(p, layer = "Raster", dpi = 200, dev = "ragg_png")
    ggsave(filename = filename, path = path, plot = p, useDingbats = FALSE, ...)
  } else {
    ggsave(filename = filename, path = path, plot = p, dpi = 200, ...)
    trim_image(fs::path(path, filename))
  }
}

