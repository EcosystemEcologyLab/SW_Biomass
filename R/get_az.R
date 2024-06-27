get_az <- function() {
  maps::map("state", "arizona", plot = FALSE, fill = TRUE) |> 
    st_as_sf() |> 
    terra::vect()
}
