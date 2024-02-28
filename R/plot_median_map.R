#' Map of median AGB across data products
#'
#' @note these plots have to be created and saved in one function.  Saving the
#'   ggplot object doesn't work with geom_spatraster
#' 
#'
#' @param agb_stack agb_stack target
#' @param subset SpatVector object to crop and mask to
#' @param downsample logical; include all pixels in the dataset or let
#'   geom_spatraster() do it's default downsampling?
#' @param path passed to ggsave()
#' @param ext file extension used to construct file name
#' @param ... additional arguments passed to ggsave(), e.g. `height`
#' 
#' @return nothing, called for side effects
#'
#' @examples
#' plot_sd_map(agb_stack)
plot_median_map <- function(agb_stack, subset, downsample = TRUE, path = "docs/fig", ext = c("png", "pdf"), ...) {
  ext <- match.arg(ext)
  filename <- paste0("map_median_", deparse(substitute(subset)), ".", ext)
  agb_median <- agb_stack |> 
    crop(subset, mask = TRUE, overwrite = TRUE) |> 
    median(na.rm = TRUE)
  
  if(isFALSE(downsample)) {
    n <- length(values(agb_median))
    p_base <- ggplot() +
      tidyterra::geom_spatraster(
        data = agb_median,
        maxcell = n 
      )
  } else {
    p_base <- ggplot() +
      tidyterra::geom_spatraster(data = agb_median)
  }
  
  #subset of colors from the scio package batlow_w palette
  map_cols <- c("#EFB298", "#C39E4B", "#7D8737", "#437153", "#185661", "#0C325D")
  
  p <- p_base +
    scale_fill_gradientn(
      colors = map_cols,
      na.value = "transparent",
      guide = guide_colorbar(barwidth = 0.6, title.position = "top")
    ) +
    theme_minimal(base_size = 9) +
    labs(fill = "AGB (Mg ha<sup>-1</sup>)") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          legend.title = element_markdown())
  
  if (fs::path_ext(filename) %in% c("pdf", "svg", "eps", "ps")) {
    p <- ggrastr::rasterise(p, layer = "Raster", dpi = 200, dev = "ragg_png") #TODO check that this is actually working
    ggsave(filename = filename, path = path, plot = p, useDingbats = FALSE, ...)
  } else {
    ggsave(filename = filename, path = path, plot = p, dpi = 200,  ...)
    trim_image(fs::path(path, filename))
  }
}