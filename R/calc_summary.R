#' Calculate summary stats on median AGB
#'
#' @param agb_stack SpatRaster with all data products
#' @param subset SpatVector to use for cropping and masking agb_stack
#' @param label character; label for this subset
#'
#' @return tibble
#' 
calc_summary <- function(agb_stack, subset) {
  agb_cropped <- crop(agb_stack, subset, mask = TRUE, overwrite = TRUE)
  agb_med <- median(agb_cropped, na.rm = TRUE)
  agb_sum <-
    zonal(c(agb_cropped, agb_med), vect(subset), fun = "sum", na.rm = TRUE) |> 
    as_tibble() |> 
    pivot_longer(everything(), names_to = "product", values_to = "sum")
  
  agb_list <- 
    c(agb_cropped, agb_med) |> 
    as.list() |> 
    set_names(c(names(agb_cropped), "median"))

  agb_list |> 
    purrr::map(\(x) {
      vals <- values(x)
      quantile(vals, na.rm = TRUE) |> 
        tibble::as_tibble_row() |> 
        rename(min = `0%`, max = `100%`, median = `50%`) |> 
        mutate(mean = mean(vals, na.rm = TRUE), subset = subset$subset) |> 
        select(subset, min, median, mean, max)
    }) |> 
    list_rbind(names_to = "product") |> 
    full_join(agb_sum) |> 
    select(subset, product, everything())
  
}

