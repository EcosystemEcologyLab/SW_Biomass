library(targets)
library(ggplot2)
library(ggridges)

tar_load(agb_df)

agb_df

plot_df <- 
  agb_df |> 
  slice_sample(n = 1000) |> #for testing, eventually use entire dataset?
  tidyr::pivot_longer(everything(), values_to = "AGB", names_to = "dataset") 

agb_max <- 
  plot_df |> 
  summarize(
    max = max(AGB, na.rm = TRUE),
    .by = dataset
  )

p <-
  ggplot(plot_df, aes(x = AGB, y = dataset, fill = dataset, color = dataset)) +
  geom_density_ridges(
    alpha = 0.5, 
    show.legend = FALSE,
    rel_min_height = 0.00000000000001, #this will need to be even smaller with full sample size probably?
    from = 0, 
    bandwidth = 0.324 #estimated joint bandwidth for full dataset.  Probably larger is fine.
  )
p

library(ggforce)

p + facet_zoom(xlim = c(50, 300)) #not helpful since can't re-normalize height and still takes up full space

library(ggbreak)

p + scale_x_break(c(50, 150), scale = 0.8) 

#works but with issues:
# https://github.com/YuLab-SMU/ggbreak/issues/59
# https://github.com/YuLab-SMU/ggbreak/issues/66

p + 
  geom_point(data = agb_max, aes(x = max, color = dataset)) + 
  scale_x_break(c(50, 100), scale = "fixed") +
  scale_color_viridis_d(aesthetics = c("color", "fill"), end = 0.95) +
  labs(x = "AGB (Mg/ha)") +
  theme_ridges(font_size = 10) +
  theme(axis.title.y = element_blank(), legend.position = "none", axis.line.x = element_line()) +
  coord_cartesian(clip = "off") #unfortunately scale_x_break seems to "turn off" coord_cartesian, so this won't work.

library(patchwork)

p1 <-
  ggplot(plot_df, aes(x = AGB, y = dataset, fill = dataset, color = dataset)) +
  geom_density_ridges(
    alpha = 0.5, 
    show.legend = FALSE,
    rel_min_height = 0.000001, #this will need to be even smaller with full sample size probably?
    from = 0,
    to = 50,
    bandwidth = 0.324 #estimated joint bandwidth for full dataset.  Probably larger is fine.
  )
p1

p2 <- 
  ggplot(plot_df, aes(x = AGB, y = dataset, fill = dataset, color = dataset)) +
  geom_density_ridges(
    alpha = 0.5, 
    show.legend = FALSE,
    rel_min_height = 0.000001, #this will need to be even smaller with full sample size probably?
    from = 50,
    to = max(agb_max$max),
    bandwidth = 0.324 #estimated joint bandwidth for full dataset.  Probably larger is fine.
  )

p2
p1 + p2 & patchwork::plot_layout(axes = "collect_y")

#collect axes doesn't work, plots are on different scales for height

#another way?
pp <- p +
  geom_point(data = agb_max, aes(x = max, color = dataset)) +
  scale_color_viridis_d(aesthetics = c("color", "fill"), end = 0.95) +
  labs(x = "AGB (Mg/ha)") +
  theme_ridges(font_size = 10) +
  theme(axis.title.y = element_blank(), legend.position = "none", axis.line.x = element_line())

p1 <- pp +
  scale_x_continuous(
    # limits = c(0, 50),
    expand = expansion(mult = c(0.05, 0)),
    breaks = scales::breaks_width(10)
  ) +
  annotate(geom = "text", label = "Z", x = 50, y = 0.5, vjust = 1) +
  coord_cartesian(xlim = c(0, 50)) 
p1

p2 <- pp + 
  scale_x_continuous(
    # limits = c(150, max(agb_max$max)),
    expand = expansion(mult = c(0, 0.05)),
    breaks = scales::breaks_width(10)
  ) +
  annotate(geom = "text", label = "Z", x = 150, y = 0.5, vjust = 1) +
  coord_cartesian(xlim = c(150, max(agb_max$max)))
p2

p1 + p2 + plot_layout(axes = "collect_y")

p1
p2
