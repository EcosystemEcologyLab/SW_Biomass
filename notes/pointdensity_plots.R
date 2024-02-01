library(targets)
library(tidyverse)
library(ggpointdensity)

tar_load(agb_stack)

agb_df <- 
  as.data.frame(agb_stack) |> 
  as_tibble()

#get a sample.  Full dataset takes a looooooong time to render plots
set.seed(134)
agb_samp <-
  agb_df |> 
  slice_sample(n = 200000)

p0 <- agb_samp |> 
  ggplot(aes(x = esa_agb_2010, y = xu_agb_2010)) +
  geom_pointdensity(adjust = 4) + #doesn't work with "auto"
  scale_color_viridis_c("point density") +
  coord_fixed() +
  labs(title = "Include all pixels")

p1 <- agb_samp |> 
  #need to remove columns where both datasets agree on zero AGB for the plot to be useful
  filter(esa_agb_2010 > 0 & xu_agb_2010 > 0) |>
  ggplot(aes(x = esa_agb_2010, y = xu_agb_2010)) +
  geom_pointdensity(adjust = 4) +
  scale_color_viridis_c("point density") +
  coord_fixed() +
  labs(title = "Exclude pixels equal to 0 in both datasets")

p2 <- agb_samp |> 
  #need to remove columns where both datasets agree on zero AGB for the plot to be useful
  # filter(!(esa_agb_2010 == 0 & chopping_agb_2010 == 0)) |> 
  # but actually this is still not very useful, since there are many values close to zero, but not zero.  Unfortunately, I think this threshold is arbitrary?
  filter(esa_agb_2010 > 10 & xu_agb_2010 > 10) |> 
  ggplot(aes(x = esa_agb_2010, y = xu_agb_2010)) +
  geom_pointdensity(adjust = 4) +
  scale_color_viridis_c("point density") +
  coord_fixed() +
  labs(title = "Exclude pixels with AGB < 10 in both datasets")

p3 <- agb_samp |> 
  #need to remove columns where both datasets agree on zero AGB for the plot to be useful
  filter(esa_agb_2010 > 0 & xu_agb_2010 > 0) |>
  ggplot(aes(x = esa_agb_2010, y = xu_agb_2010)) +
  geom_pointdensity(adjust = 4) +
  scale_color_viridis_c("point density", trans = "log10") +
  coord_fixed() +
  labs(title = "Exclude 0s and use log scale for color")

ggsave("docs/fig/scatter0.png", p0) |> trim_image()
ggsave("docs/fig/scatter1.png", p1) |> trim_image()
ggsave("docs/fig/scatter2.png", p2) |> trim_image()
ggsave("docs/fig/scatter3.png", p3) |> trim_image()

#try with liu

p4 <- agb_samp |> 
  #need to remove columns where both datasets agree on zero AGB for the plot to be useful
  filter(esa_agb_2010 > 0 & liu_agb_2010 > 0) |>
  ggplot(aes(x = esa_agb_2010, y = liu_agb_2010)) +
  geom_pointdensity(adjust = 2) +
  scale_color_viridis_c("point density") +
  coord_fixed() +
  labs(title = "Exclude pixels equal to 0 in both datasets")

ggsave("docs/fig/scatter_liu.png", p4) |> trim_image()
