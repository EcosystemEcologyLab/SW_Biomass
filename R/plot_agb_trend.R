# agb_stats
# library(ggplot2)
# library(dplyr)
# library(ggdist)

plot_agb_trend <- function(agb_stats) {
  
  agb_stats |> 
    filter(nchar(year) == 4) |> 
    ggplot(aes(x = as.integer(year), y = median, color = product, fill = product)) +
    facet_wrap(vars(subset), scales = "free_y") +
    # geom_ribbon(aes(ymin = q02.5, ymax = q97.5), color = NA, alpha = 0.4) +
    # geom_ribbon(aes(ymin = q10, ymax = q90), color = NA, alpha = 0.4) +
    geom_ribbon(aes(ymin = q25, ymax = q75), color = NA, alpha = 0.4) +
    geom_line() +
    scale_color_brewer(palette = "Dark2", aesthetics = c("color", "fill")) +
    labs(x = "", y = "AGB (Mg/ha)", caption = "median ± IQR AGB")
  
}