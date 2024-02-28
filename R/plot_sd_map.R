#' Map of standard deviation of AGB across data products
#' 
#' @note these plots have to be created and saved in one function.  Saving the
#'   ggplot object doesn't work with geom_spatraster
#'
#' @param agb_stack agb_stack target
#' @param subset SpatVector object to crop and mask agb_stack
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
plot_sd_map <- function(agb_stack, subset, downsample = TRUE, path = "docs/fig", ext = c("png", "pdf"), ...) {
  ext <- match.arg(ext)
  filename <- paste0("map_sd_", deparse(substitute(subset)), ".", ext)
  
  agb_sd <- agb_stack |> 
    crop(subset, mask = TRUE, overwrite = TRUE) |> 
    stdev(na.rm = TRUE)
  
  #I add 1 to the data here because trans = "log1p" and scales::breaks_log()
  #don't work together. So, this is the first half of a log(x+1) transformation.
  if(isFALSE(downsample)) {
    n <- length(values(agb_sd))
    p_base <- ggplot() +
      tidyterra::geom_spatraster(
        data = agb_sd + 1, 
        maxcell = n 
      )
  } else {
    p_base <- ggplot() +
      tidyterra::geom_spatraster(data = agb_sd + 1)
  }
  
  p <-
    p_base +
    # Here is the log part of the log(x+1) transformation of the color scale
    scale_fill_viridis_c(
      option = "viridis",
      trans = "log10",
      breaks = scales::breaks_log(5),
      na.value = "transparent",
      guide = guide_colorbar(barwidth = 0.6, title.position = "top")
    ) +
    theme_minimal(base_size = 9) +
    labs(fill = "SD AGB (Mg ha<sup>-1</sup>)") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          legend.title = element_markdown())
  
  if (fs::path_ext(filename) %in% c("pdf", "svg", "eps", "ps")) {
    p <- ggrastr::rasterise(p, layer = "Raster", dpi = 200, dev = "ragg_png")
    ggsave(filename = filename, path = path, plot = p, useDingbats = FALSE, ...)
  } else {
    ggsave(filename = filename, path = path, plot = p, dpi = 200, ...)
    trim_image(fs::path(path, filename))
  }

}