# use branching to apply this to all the raster datasets and rowbind the results
extract_agb_site <- function(rast, sites) {
  site_buffer <- sites |> st_buffer(1000) |> vect()
  
  # zonal() is slightly faster than extract()
  site_agb <- terra::zonal(rast, site_buffer, exact = TRUE, na.rm = TRUE)
  
  out <- site_agb |> 
    #TODO this might not be working
    rename(agb = 1) |>
    mutate(
      product = names(rast), #TODO this isn't working. need to get the object name instead I guess? tricky Or maybe use names(rast)?
      site_rowid = 1:n()
      ) |> as_tibble()
  out  
}

#somethign liek this to join them all
  # full_join(sites |> as_tibble(xy = TRUE, rownames = "site_rownum"),
  #           out |> pivot_wider(names_from = product, values_from = agb))
  