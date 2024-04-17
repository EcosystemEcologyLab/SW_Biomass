library(targets)
library(car)
library(colorspace)
library(ggpattern)
tar_load_globals()
# tar_load(conus)
tar_load(az)
xu <- rast("data/rasters/Xu/test10a_cd_ab_pred_corr_2000_2019_v2.tif", win = ext(az))
xu <- xu |> mask(st_transform(az, crs(xu)))
names(xu) <- 2000:2019

plot(xu[[1]])

# calculate slope in AGB over time with pixel-wise regression
get_lm_slope <- function(rast_stack) {
  # pixel-wise p-values not currently working, but this is not high priority as
  # it's not really an appropriate method for assessing statistical significance
  # anyway
  years <- as.integer(names(rast_stack))
  getTrend <- function(x) {
    if (any(is.na(x))) {
      c(slope = NA, p.val = NA)
    } else {
      m = lm(x ~ years)
      #if residual sum of squares is 0, p-value can't be calculated
      # not sure if Inf is always appropriate, but I want these to be masked out in the plot along with non-significant p-values
      if (sum(m$residuals^2)==0) {
        c(slope = coef(m)[2], p.val = Inf)
      } else {
        c(slope = coef(m)[2], p.val = car::Anova(m)$`Pr(>F)`[1])
      }
    }
  }
  
  slope_rast <- app(rast_stack, getTrend)
  slope_rast[[2]] <- app(slope_rast[[2]], p.adjust, method = "fdr")
  names(slope_rast) <- c("slope", "p.value")
  
  #return
  slope_rast
}
xu_slope <- get_lm_slope(xu)

# convert p-val layer into polygons
non_sig <- 
  as.polygons(xu_slope[["p.value"]] < 0.05) |>
  filter(p.value == 0)  |>
  mutate(p.value = as.factor(p.value))




p <- ggplot() +
  geom_spatraster(data = xu_slope, aes(fill = slope)) +
  scale_fill_continuous_diverging(na.value = "transparent") +
  labs(title = "Estimated Trends in AGB (2000-2019)", caption = "Data from Xu et al. (2021). Slopes from pixel-wise linear regression.",
       fill = "∆AGB (Mg/ha/yr)") +
  theme_dark()
p
ggsave("docs/fig/xu_trend_az.png", height = 7) |> trim_image()

#with p-value info

p +
  geom_sf_pattern(
    data = st_as_sf(non_sig),
    aes(pattern_fill = ""),
    pattern = "crosshatch",
    fill = NA,
    colour = NA,
    pattern_alpha = 0.5, #maybe not necessary
    pattern_size = 0.05, #make lines smaller
    pattern_spacing = 0.01, #make lines closer together
    pattern_res = 200, #make lines less pixelated
  ) +
  scale_pattern_fill_manual("p > 0.05", values = c("grey30"))
