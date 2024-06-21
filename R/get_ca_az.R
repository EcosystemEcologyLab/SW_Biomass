#creates a CA + AZ sf object for use in cropping
get_ca_az <- function() {
  sf_use_s2(FALSE)
  maps::map("state", c("arizona", "california"), plot = FALSE, fill = TRUE) |>
    st_as_sf() |>
    st_make_valid() |>
    st_union() |> 
    terra::vect()
}