#' Scatter plot comparing data products to ESA CCI
#'
#' @param agb_stack the agb_stack target, a SpatRaster with one layer per data product
#' @param comparison the data product to compare to ESA CCI
#' @param n integer; the number of pixels to sample for the plot. This might
#'   work with the full dataset, but the result will be a black blob because of
#'   all the over-plotting, and it might crash R or at the very least take a long time.
#' @param save_dir directory to save the file in. File name will depend on the value of `comparison`
#' @param ext file extension to pass to ggsave.  If the extension is a vector
#'   filetype (pdf, eps, ps, svg), the point layer will be rasterized with
#'   ggrastr::rasterise()
#' @param ... other arguments passed to `ggsave()`, e.g. `height` and `width`
#'
#' @return file path for save plot
#' 
plot_scatter <-
  function(agb_stack,
           comparison = names(agb_stack)[names(agb_stack) != "ESA CCI"],
           n = 200000,
           save_dir = "docs/fig/",
           ext = "png",
           ...) {
  sel <- match.arg(comparison)
  agb_df <- 
    as.data.frame(agb_stack) |> 
    as_tibble() |> 
    drop_na() |> 
    slice_sample(n = n) |>
    dplyr::select("ESA CCI", all_of(sel))
  
  agb_max <- max(agb_df, na.rm = TRUE)
  
  p <- 
    ggplot(agb_df, aes(x = `ESA CCI`, y = .data[[sel]])) +
    geom_point(alpha = 0.05) +
    coord_fixed(xlim = c(0, agb_max), ylim = c(0, agb_max)) +
    labs(x = "ESA CCI (Mg ha<sup>-1</sup>)",
         y = glue::glue("{sel} (Mg ha<sup>-1</sup>)")) +
    theme_linedraw(base_size = 9) +
    theme(axis.title.x = ggtext::element_markdown(),
          axis.title.y = ggtext::element_markdown())
  
  #rasterize point layer?
  if (ext %in% c("eps", "ps", "pdf", "svg")) {
    p <- ggrastr::rasterise(p, layer = "Point", dpi = 200, dev = "ragg_png")
  }
  
  filename <- paste("scatter", snakecase::to_snake_case(sel), sep = "_")
  save_path <- fs::path(save_dir, filename, ext = ext)
  ggsave(save_path, plot = p, ...)
}
# targets::tar_load(agb_stack)
# plot_scatter(agb_stack, n =  100, ext = "png")

