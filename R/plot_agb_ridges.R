#' Plot AGB distribution as ridge plot
#' 
#' uses ggridges package
#'
#' @param agb_stack agb_stack target
#' @param subset SpatVector object to crop and mask agb_stack
#' @param break_x numeric; where to end the x-axis in the first panel.  The
#'   xlims of the second panel are determined from the data.
#' @param est_separate logical; do the density kernel estimate separately for
#'   the two panels?
#' @param rel_widths length 2 numeric vector for relative widths of the two panels.
#'   Passed to patchwork::plot_layout(widths = rel_widths)
#' @param path passed to ggsave()
#' @param filename passed to ggsave().  Include file extension desired for output (e.g. .png or .pdf)
#' @param ... additional arguments passed to ggsave(), e.g. `height`
#' 
#' @return file path
plot_agb_ridges <- function(agb_stack, subset, est_separate = FALSE, break_x = 20, rel_widths = c(1, 0.5), path = "docs/fig", filename = "agb_ridge.png", ...) {
  
  #TODO consider making the break programmatically? Like, figure out where the densities all level out and then figure out where the min of the maxes is.
  agb_df <- 
    agb_stack |>
    crop(subset, mask = TRUE) |>
    as.data.frame() |>
    as_tibble()
  
  #joint bandwidth estimation
  bw <- 
    map_dbl(agb_df, \(x) bw.nrd0(x[is.finite(x)])) |> 
    mean()
  
  if (isFALSE(est_separate)) {
    dens <- agb_df |> 
      purrr::map(\(x) {
        bkde(x[is.finite(x)], bandwidth = bw, gridsize = 10000)
      }) |> 
      purrr::map(as_tibble) |> 
      list_rbind(names_to = "group")
    
    smallest_max <- dens |> 
      group_by(group) |> 
      summarize(max = max(x)) |> 
      pull(max) |> 
      min()
    
    p <- 
      ggplot(dens, aes(x, height = y, y = group, color = group, fill = group))  +
      geom_density_ridges(stat = "identity", alpha = 0.5) +
      scale_color_viridis_d(aesthetics = c("color", "fill"), end = 0.95) +
      labs(x = "AGB (Mg ha<sup>-1</sup>)") +
      theme_ridges(font_size = 9) + 
      theme(axis.title.y = element_blank(),
            axis.title.x = element_markdown(),
            legend.position = "none")
    
    p_out <- 
      (p + coord_cartesian(xlim = c(0, break_x))) + 
      (p + 
         scale_x_continuous(breaks = scales::breaks_pretty(n = 4)) +
         coord_cartesian(xlim = c(smallest_max-5, max(dens$x))))  +
      plot_layout(axes = "collect", widths = rel_widths)
    
  } else {
    dens1 <- agb_df |> 
      purrr::map(\(x) {
        bkde(
          x[is.finite(x)],
          range.x = c(min(x, na.rm = TRUE), break_x),
          bandwidth = bw,
          gridsize = 10000
        )
      }) |> 
      purrr::map(as_tibble) |> 
      list_rbind(names_to = "group")
    
    dens2 <- agb_df |> 
      purrr::map(\(x) {
        bkde(
          x[is.finite(x)],
          range.x = c(break_x, max(x, na.rm = TRUE)),
          bandwidth = bw,
          gridsize = 10000
        )
      }) |> 
      purrr::map(as_tibble) |> 
      list_rbind(names_to = "group")
    
    p1 <- 
      ggplot(dens1, aes(x, height = y, y = group, color = group, fill = group)) +
      geom_density_ridges(stat = "identity", alpha = 0.5) +
      scale_color_viridis_d(aesthetics = c("color", "fill"), end = 0.95) +
      labs(x = "AGB (Mg ha<sup>-1</sup>)") +
      theme_ridges(font_size = 10) + 
      theme(axis.title.y = element_blank(),
            axis.title.x = element_markdown(),
            legend.position = "none")
    
    p2 <- 
      ggplot(dens2, aes(x, height = y, y = group, color = group, fill = group)) +
      geom_density_ridges(stat = "identity", alpha = 0.5) +
      scale_color_viridis_d(aesthetics = c("color", "fill"), end = 0.95) +
      labs(x = "AGB (Mg ha<sup>-1</sup>)") +
      theme_ridges(font_size = 10) + 
      theme(axis.title.y = element_blank(),
            axis.title.x = element_markdown(),
            legend.position = "none")
    
    # Not very flexible.  Needed to get y-axis ticks to match up between panels,
    # but if things change, this will need manual editing.
    p_out <- 
      (p1 + p2 & coord_cartesian(ylim = c(1, 7.5))) +
      plot_layout(axes = "collect", widths = rel_widths)
  }
  
  if (fs::path_ext(filename) %in% c("pdf", "svg", "eps", "ps")) {
    ggsave(filename = filename, path = path, plot = p_out, useDingbats = FALSE, ...)
  } else {
    ggsave(filename = filename, path = path, plot = p_out, dpi = 200, ...)
  }
}
