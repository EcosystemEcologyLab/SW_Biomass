library(targets)
library(tidyverse)
library(ggpointdensity)
library(patchwork)

tar_load(agb_stack)

agb_df <- 
  as.data.frame(agb_stack) |> 
  as_tibble()

#get a sample.  Full dataset takes a looooooong time to render plots and even runs out of memory
set.seed(134)
n <- 20000
adj <- 10 # passed to geom_pointdensity(adjust = )
cap <- glue::glue("Sample (n = {scales::number(n, big.mark = ",")})")

agb_samp <-
  agb_df |> 
  slice_sample(n = n)

#example datasets to compare to
comp <- c("Xu et al.", "Liu et al.", "LT-GNN")

all <- 
  map(comp, \(x) {
    agb_samp |> 
      #this is a "trick" to plot brightest points on top https://github.com/LKremer/ggpointdensity/issues/15
      ggplot(aes(x = stage(`ESA CCI`, after_stat = x[order(density)]), y = stage(.data[[x]], after_stat = y[order(density)]), color = after_stat(sort(density)))) +
      geom_pointdensity(adjust = adj) + 
      scale_color_viridis_c() +
      labs(x = "ESA CCI", y = x, color = "density") +
      theme_linedraw(base_size = 9)
  })
p_all <- wrap_plots(all, ncol = 1) + 
  plot_layout(axes = "collect_x") + 
  plot_annotation(title = "All points", caption = cap)
p_all
ggsave("docs/fig/scatter_all.png", p_all, height = 5, width = 4)

non0 <-
  map(comp, \(x) {
    agb_samp |> 
      #need to remove columns where both datasets agree on zero AGB for the plot to be useful
      filter(`ESA CCI` > 0 & .data[[x]] > 0) |>
      ggplot(aes(x = stage(`ESA CCI`, after_stat = x[order(density)]), y = stage(.data[[x]], after_stat = y[order(density)]), color = after_stat(sort(density))))  +
      geom_pointdensity(adjust = adj) +
      scale_color_viridis_c() +
      labs(x = "ESA CCI", y = x, color = "density") +
      theme_linedraw(base_size = 9)
  })
p_non0 <- wrap_plots(non0, ncol = 1) + 
  plot_layout(axes = "collect_x") +
  plot_annotation(title = "Exclude pixels equal to 0 in both datasets", caption = cap)
p_non0
ggsave("docs/fig/scatter_non0.png", p_non0, height = 5, width = 4)

gr10 <- map(comp, \(x) {
  agb_samp |> 
    #need to remove columns where both datasets agree on zero AGB for the plot to be useful
    # filter(!(esa_agb_2010 == 0 & chopping_agb_2010 == 0)) |> 
    # but actually this is still not very useful, since there are many values close to zero, but not zero.  Unfortunately, I think this threshold is arbitrary?
    filter(`ESA CCI` > 10 & .data[[x]] > 10) |> 
    ggplot(aes(x = stage(`ESA CCI`, after_stat = x[order(density)]), y = stage(.data[[x]], after_stat = y[order(density)]), color = after_stat(sort(density))))  +
    geom_pointdensity(adjust = adj) +
    scale_color_viridis_c() +
    labs(x = "ESA CCI", y = x, color = "density") +
    theme_linedraw(base_size = 9)
})
p_gr10 <- wrap_plots(gr10, ncol = 1) + 
  plot_layout(axes = "collect_x") +
  plot_annotation(title = "Exclude pixels < 10 Mg/ha in both datasets", caption = cap)
p_gr10
ggsave("docs/fig/scatter_gr10.png", p_gr10, height = 5, width = 4)

#another option is to log-transform the color scale
# p_all & scale_color_viridis_c(trans = "log1p")
p_log <- p_non0 & scale_color_viridis_c(trans = "log10") & plot_annotation(subtitle = "Color on log scale")
p_log
ggsave("docs/fig/scatter_log.png", p_log, height = 5, width = 4)
