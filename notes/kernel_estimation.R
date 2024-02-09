library(targets)
library(tidyverse)

tar_load(agb_df)
sel <- "Xu et al."
data <- 
  agb_df |> 
  select(x = `ESA CCI`, y = .data[[sel]])


h <- c(bw.nrd0(data$x), bw.nrd0(data$y))
# h <- c(KernSmooth::dpik(data$x, scalest = "stdev", gridsize = 400L),
#        KernSmooth::dpik(data$y, scalest = "stdev", gridsize = 400L))
h

# dens <- MASS::kde2d(x = data$x, y = data$y, h = h)

# MASSExtra version supposedly scales better to large data
# dens <- MASSExtra::kde_2d(x = data$x, y = data$y, bw = h)

dens <-
  KernSmooth::bkde2D(
    x = cbind(data$x, data$y),
    bandwidth = h,
    gridsize = c(400L, 400L),
    range.x = list(c(0, max(data)), c(0, max(data)))
  )


ix <- findInterval(data$x, dens$x1)
iy <- findInterval(data$y, dens$x2)
ii <- cbind(ix, iy)
# data$density <- dens$z[ii]
data$density <- dens$fhat[ii]

#TODO: shouldn't dupliacte points get summed together or somethign?  Like, isn't that the whole point?
data |> slice_head(n = 1000) |> duplicated() |> sum()

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
