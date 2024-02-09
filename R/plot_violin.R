plot_violin <- function(agb_df, save_path = "docs/fig/violin.png", n = 10000, ...) {
  plot_df <- 
    agb_df |> 
    dplyr::slice_sample(n = n) |> #without this, the plot is suuuuper slow.
    tidyr::pivot_longer(everything(), values_to = "AGB", names_to = "dataset") 
  
  p <- plot_df |> 
    ggplot(aes(x = dataset, y = AGB)) +
    geom_violin(draw_quantiles = c(0.25, 0.5, 0.75), scale = "width") +
    scale_x_discrete(labels = \(x) str_remove(x, "_agb_.+")) +
    labs(title = "Sample (n = 5000) of AGB raster data for AZ", y = "AGB (Mg/ha)", x = "Data Product")
  ggsave(save_path, p, ...)
}