make_shape_list <- function(crs, srer_dir, pima_dir) {
  az_sf <- maps::map("state", "arizona", plot = FALSE, fill = TRUE) |> 
    st_as_sf() |> 
    st_transform(crs)
  ca_sf <- maps::map("state", "california", plot = FALSE, fill = TRUE) |> 
    st_as_sf() |> 
    st_transform(crs)
  srer_sf <- st_read(srer_dir) |> 
    st_transform(crs)
  pima_sf <- st_read(pima_dir) |> 
    st_transform(crs)
  
  list("AZ" = az_sf, "CA" = ca_sf, "SRER" = srer_sf, "pima" = pima_sf)
}