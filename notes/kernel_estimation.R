library(targets)
library(tidyverse)

tar_load(agb_stack)
sel <- "Xu et al."
data <- 
  agb_stack |> 
  as.data.frame() |> 
  as_tibble() |> 
  select(x = `ESA CCI`, y = `Xu et al.`)


h <- c(bw.nrd0(data$x), bw.nrd0(data$y))
h

# dens <- MASS::kde2d(x = data$x, y = data$y, h = h)

# MASSExtra version supposedly scales better to large data
# dens <- MASSExtra::kde_2d(x = data$x, y = data$y, bw = h)

dens <- KernSmooth::bkde2D(x = cbind(data$x, data$y), bandwidth = h, gridsize = c(200L, 200L))


ix <- findInterval(data$x, dens$x1)
iy <- findInterval(data$y, dens$x2)
ii <- cbind(ix, iy)
# data$density <- dens$z[ii]
data$density <- dens$fhat[ii]

agb_max <- max(data)

p <- ggplot(data, aes(x, y, color = density)) +
  ggrastr::rasterize(geom_point(), dev = "ragg_png") + #default 72 dpi
  coord_fixed(xlim = c(0, agb_max), ylim = c(0, agb_max)) +
  scale_color_viridis_c(option = "magma") +
  labs(x = "ESA CCI (Mg ha<sup>-1</sup>)",
       y = glue::glue("{sel} (Mg ha<sup>-1</sup>)")) +
  theme_linedraw(base_size = 9) +
  theme(axis.title.x = ggtext::element_markdown(),
        axis.title.y = ggtext::element_markdown())

plog <- p +
  scale_color_viridis_c(option = "magma", trans = "log10", labels = scales::label_log(), breaks = scales::breaks_log())

ggsave("test_KernSmooth.png", p)
ggsave("test_KernSmooth_log.png", plog)
