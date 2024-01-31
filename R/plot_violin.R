plot_violin <- function(agb_stack, ...) {
  agb_df <- 
    as.data.frame(agb_stack) |> 
    dplyr::as_tibble() |> 
    dplyr::slice_sample(n = 5000) |> #without this, the plot is suuuuper slow.
    tidyr::pivot_longer(everything(), values_to = "AGB", names_to = "dataset") 
  
  p <- agb_df |> 
    ggplot(aes(x = dataset, y = AGB)) +
    geom_violin(draw_quantiles = c(0.25, 0.5, 0.75), scale = "width") +
    scale_x_discrete(labels = \(x) str_remove(x, "_agb_2010")) +
    labs(title = "Sample (n = 5000) of AGB raster data for AZ", y = "AGB (Mg/ha)", x = "Data Product")
  ggsave("fig/violin.png", p, ...)
}