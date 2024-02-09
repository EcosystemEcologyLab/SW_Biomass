#' Plot AGB distribution as ridge plot
#' 
#' uses ggridges package
#'
#' @param agb_df The agb_stack target, a tibble
#' @param save_path path to save plot
#' @param n when a positive integer is supplied, the number of pixels to sample
#'   from `agb_stack`. Use `n = "all"` to skip the sampling step.  Warning, with
#'   larger samples or with all data, the plot will be extremely slow to render
#'   because the density calculation step is slow. With all data, this function
#'   currently errors on my computer because it runs out of memory.
#' @param labels logical; plot the graph with axis labels?
#' @param ... other arguments passed to `ggsave()`
#'
#' @return save_path
plot_agb_ridges <- function(agb_df, save_path = "docs/fig/agb_ridge.png", n = 5000, labels = TRUE, ...) {

  if(is.numeric(n)) {
    agb_df <- agb_df |> dplyr::slice_sample(n = n)
  } else if (n == "all") {
    agb_df <- agb_df
  }
  
  plot_df <- 
    agb_df |> 
    tidyr::pivot_longer(everything(), values_to = "AGB", names_to = "dataset") 
  
  max_agb <- plot_df |> 
    dplyr::summarize(max_agb = max(AGB, na.rm = TRUE), .by = dataset)
  
  #TODO if you want the possibility of a transformed x-axis, figure out how to do it correctly.
  # - scale_x_continuous(trans = "log1p") seems to change the range of the data.  I don't think it's supposed to do that?
  # - coord_trans(x = "log1p") does the transformation graphically, so each bin in the density plot is stretched or squished.  This doesn't seem right.
  
  p <-
    ggplot(plot_df, aes(x = AGB, y = dataset, fill = dataset, color = dataset)) +
    geom_density_ridges(
      alpha = 0.5, 
      show.legend = FALSE,
      rel_min_height = 0.000001, #this will need to be even smaller with full sample size probably?
      from = 0,
      bandwidth = 2
    ) +
    # scale_x_continuous(trans = "log1p") +
    scale_color_viridis_d(aesthetics = c("color", "fill"), end = 0.95) +
    labs(x = "AGB (Mg/ha)") +
    theme_ridges(font_size = 10) + 
    theme(axis.title.y = element_blank()) +
    coord_cartesian(clip = "off") #prevent top ridge from being cut off?
  
  if(isFALSE(labels)) {
    p <- p + theme(axis.title = element_blank(), axis.text = element_blank())
  }
  ggsave(save_path, p, ...)
}
# plot_agb_ridges(agb_stack, height = 2, width = 4)
# plot_agb_ridges(agb_stack, save_path = "docs/fig/agb_ridge_sqrt.png", xtrans = "sqrt", height = 2, width = 4)
