library(targets)
tar_load_globals()
tar_load(agb_df)

# Prep data ---------------------------------------------------------------
plot_df <- 
  agb_df |> 
  slice_sample(n = 500000) |> #for testing, eventually use entire dataset?
  tidyr::pivot_longer(everything(), values_to = "AGB", names_to = "dataset") 

agb_max <- 
  plot_df |> 
  summarize(
    max = max(AGB, na.rm = TRUE),
    .by = dataset
  )


# Plots -------------------------------------------------------------------
#two possibilities for ridge plots
#First, estimate density separately for 0-40 and 40-max

p1 <-
  ggplot(plot_df, aes(x = AGB, y = dataset, fill = dataset, color = dataset)) +
  geom_density_ridges(
    alpha = 0.5, 
    show.legend = FALSE,
    rel_min_height = 0.0000001, 
    from = 0,
    to = 30,
    # bandwidth = 0.324 #estimated joint bandwidth for full dataset.  Probably larger is fine.
  ) +
  theme_ridges(font_size = 10) +
  theme(axis.title.y = element_blank())
p1 

p2 <- 
  ggplot(plot_df, aes(x = AGB, y = dataset, fill = dataset, color = dataset)) +
  geom_density_ridges(
    alpha = 0.5, 
    show.legend = FALSE,
    rel_min_height = 0.0000001,
    from = 30,
    to = max(agb_max$max),
    # bandwidth = 0.324 #estimated joint bandwidth for full dataset.  Probably larger is fine.
  ) +
  geom_point(data = agb_max, aes(x = max, color = dataset)) +
  theme_ridges(font_size = 10) +
  theme(axis.title.y = element_blank(), legend.position = "none")
p2

(p1 + p2 & coord_cartesian(ylim = c(1,8))) + 
  plot_layout(widths = c(1, 0.5), axes = "collect")

ggsave("docs/fig/ridge_opt1.png", height = 2)

# Pros: tail end is "blown up" to magnify differences
# Cons: tail is on different scale and to get it to line up with head, head difference are slighly obscured

# Second approach, plot 0-30, and 100-max but on the same density calculation
p_full <-
  ggplot(plot_df, aes(x = AGB, y = dataset, fill = dataset, color = dataset)) +
  geom_density_ridges(
    alpha = 0.5, 
    show.legend = FALSE,
    rel_min_height = 0.000001, 
    from = 0, 
    # bandwidth = 0.324 #estimated joint bandwidth for full dataset.  Probably larger is fine.
  ) +
  geom_point(data = agb_max, aes(x = max, color = dataset)) +
  theme_ridges(font_size = 10) +
  theme(legend.position = "none", axis.title.y = element_blank())
p_a <- 
  p_full + coord_cartesian(xlim = c(0, 30))
p_a

p_b <-
  p_full + coord_cartesian(xlim = c(100, max(agb_max$max)))

p_a + p_b + plot_layout(widths = c(1, 0.5), axes = "collect")
ggsave("docs/fig/ridge_opt2.png", height = 2)

#Pros: more compact, both panels are on the same scale. Equivalent to a "broken" axis
#Cons: can't see distribution in tails well, only difference in range