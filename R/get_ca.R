get_ca <- function() {
  maps::map("state", "california", plot = FALSE, fill = TRUE) |> 
    st_as_sf() |> 
    terra::vect()
}