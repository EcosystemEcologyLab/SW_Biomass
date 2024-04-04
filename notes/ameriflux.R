library(targets)
tar_load_globals()
library(amerifluxr)


site_info_raw <- amf_site_info() 
unique(site_info_raw$COUNTRY)
colnames(site_info_raw)
site_info_raw |> 
  dplyr::filter(COUNTRY == "USA", !STATE %in% c("AK", "HI")) |> 
  st_as_sf(coords = c("LOCATION_LONG", "LOCATION_LAT"))

unique(site_info_raw$STATE)
