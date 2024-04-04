library(targets)
tar_load_globals()
library(amerifluxr)
tar_load(gedi_agb)

site_info_raw <- amf_site_info() 

amf_vect <- site_info_raw |> 
  dplyr::filter(COUNTRY == "USA", !STATE %in% c("AK", "HI")) |> 
  vect(geom = c("LOCATION_LONG", "LOCATION_LAT"))
crs(amf_vect) <- "+proj=longlat"

#1km buffer around each point
amf_buffer <- buffer(amf_vect, width = 1000)

out <- extract(gedi_agb, amf_buffer, fun = mean, ID = TRUE)

out2 <- amf_vect |> as_tibble(xy = TRUE) |> add_column(gedi_agb = out$`GEDI L4B`)
View(out2)

tar_load(site_locs)
rast <- gedi_agb
site_buffer <- site_locs |> st_buffer(1000) |> vect()

site_agb <- extract(rast, site_buffer, fun = mean, exact = TRUE, na.rm = TRUE)
site_locs |> as_tibble(xy = TRUE) |> add_column(!!varnames(rast) := site_agb[[2]])
