make_az_sf <- function(esa_crs) {
  maps::map("state", "arizona", plot = FALSE, fill = TRUE) |> 
    st_as_sf() |> 
    st_transform(esa_crs)
}
