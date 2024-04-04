# use branching to apply this to all the raster datasets and rowbind the results
extract_agb_site <- function(rast, sites) {
  site_buffer <- sites |> st_buffer(1000) |> vect()
  
  site_agb <- terra::extract(rast, site_buffer, fun = mean, exact = TRUE, na.rm = TRUE)
  out <- site_agb |> 
    rename(site_rownum = 1, agb = 2) |>
    mutate(
      site_rownum = as.character(site_rownum),
      product = varnames(rast)
      )
  out  
}

#somethign liek this to join them all
  # full_join(sites |> as_tibble(xy = TRUE, rownames = "site_rownum"),
  #           out |> pivot_wider(names_from = product, values_from = agb))
  