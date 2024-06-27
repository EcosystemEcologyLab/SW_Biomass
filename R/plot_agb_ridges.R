#' Plot AGB distribution as ridge plot
#' 
#' uses ggridges package
#'
#' @param agb_stack agb_stack target
#' @param subset SpatVector object to crop and mask agb_stack
#' @param break_plot logical; break the x-axis and plot as two panels?
#' @param break_x numeric; where to end the x-axis in the first panel. When only
#'   a single number is provided, the xlims of the second panel are determined
#'   from the data. You can optionally provide a vector of 2 numbers to manually
#'   set the lower xlim of the second panel. Has no effect when `break_plot =
#'   FALSE`
#' @param rel_widths length 2 numeric vector for relative widths of the two
#'   panels. Passed to `patchwork::plot_layout(widths = rel_widths)`. Has no
#'   effect when `break_plot = FALSE`
#' @param path passed to ggsave()
#' @param filename passed to ggsave().  Include file extension desired for output (e.g. .png or .pdf)
#' @param ... additional arguments passed to ggsave(), e.g. `height`
#' 
#' @return file path
plot_agb_ridges <- function(agb_stack, subset, break_plot = TRUE, break_x = 20, rel_widths = c(1, 0.5), path = "docs/fig", filename = "agb_ridge.png", ...) {
  subset <- project(subset, agb_stack)
  agb_df <- 
    agb_stack |>
    terra::crop(subset, mask = TRUE, overwrite = TRUE) |>
    as.data.frame() |>
    as_tibble()
  
  #joint bandwidth estimation
  bw <- 
    map_dbl(agb_df, \(x) bw.nrd0(x[is.finite(x)])) |> 
    mean()
  
  dens <- agb_df |> 
    purrr::map(\(x) {
      bkde(x[is.finite(x)], bandwidth = bw, gridsize = 10000)
    }) |> 
    purrr::map(as_tibble) |> 
    list_rbind(names_to = "group")
  
  p <- 
    ggplot(dens, aes(x, height = y, y = group, color = group, fill = group))  +
    geom_density_ridges(stat = "identity", alpha = 0.5) +
    scale_color_viridis_d(aesthetics = c("color", "fill"), end = 0.95) +
    labs(x = "AGB (Mg ha<sup>-1</sup>)") +
    theme_ridges(font_size = 9) + 
    theme(axis.title.y = element_blank(),
          axis.title.x = element_markdown(),
          legend.position = "none")
  
  if (isTRUE(break_plot)) {
    if (length(break_x) == 1) {
      smallest_max <- dens |> 
        group_by(group) |> 
        summarize(max = max(x)) |> 
        pull(max) |> 
        min()
      break_x <- c(break_x, smallest_max-5)
    }
    
    p_out <- 
      (p + coord_cartesian(xlim = c(0, break_x[1]))) + 
      (p + 
         scale_x_continuous(breaks = scales::breaks_pretty(n = 4)) +
         coord_cartesian(xlim = c(break_x[2], max(dens$x))))  +
      plot_layout(axes = "collect", widths = rel_widths)
  } else {
    p_out <- p
  }
  
  if (fs::path_ext(filename) %in% c("pdf", "svg", "eps", "ps")) {
    ggsave(filename = filename, path = path, plot = p_out, useDingbats = FALSE, ...)
  } else {
    ggsave(filename = filename, path = path, plot = p_out, dpi = 200, bg = "white", ...)
  }
}
