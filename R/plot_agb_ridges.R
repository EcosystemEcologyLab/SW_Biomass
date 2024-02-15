#' Plot AGB distribution as ridge plot
#' 
#' uses ggridges package
#'
#' @param agb_df The agb_stack target, a tibble
#' @param break_x a length 2 numeric vector for what part of the x-axis to omit.
#'   By default it plots AGB 0-20 on the first panel and 100-max(AGB) in the
#'   second panel.
#' @param est_separate logical; do the density kernel estimate separately for
#'   the two panels?
#' @param widths length 2 numeric vector for relative widths of the two panels.
#'   Passed to patchwork::plot_layout()
#' @return ggplot object
plot_agb_ridges <- function(agb_df, est_separate = FALSE, break_x = c(20, 100), widths = c(1, 0.5)) {
  
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
    
    p <- 
      ggplot(dens, aes(x, height = y, y = group, color = group, fill = group))  +
      geom_density_ridges(stat = "identity", alpha = 0.5) +
      scale_color_viridis_d(aesthetics = c("color", "fill"), end = 0.95) +
      labs(x = "AGB (Mg ha<sup>-1</sup>)") +
      theme_ridges(font_size = 10) + 
      theme(axis.title.y = element_blank(),
            axis.title.x = element_markdown(),
            legend.position = "none")
    
    (p + coord_cartesian(xlim = c(0, break_x[1]))) + 
      (p + coord_cartesian(xlim = c(break_x[2], max(dens$x))))  +
      plot_layout(axes = "collect", widths = widths)
  
  } else {
    dens1 <- agb_df |> 
      purrr::map(\(x) {
        bkde(x[is.finite(x)], range.x = c(0, break_x[1]), bandwidth = bw, gridsize = 10000)
      }) |> 
      purrr::map(as_tibble) |> 
      list_rbind(names_to = "group")
    
    max_agb <- agb_df |> 
      purrr::map_dbl(max, na.rm = TRUE) |> max()
    
    dens2 <- agb_df |> 
      purrr::map(\(x) {
        bkde(x[is.finite(x)], range.x = c(break_x[1], max_agb), bandwidth = bw, gridsize = 10000)
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
    (p1 + p2 & coord_cartesian(ylim = c(1, 7.5))) +
      plot_layout(axes = "collect", widths = widths)
  }
  
}
