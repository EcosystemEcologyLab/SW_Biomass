#' Calculate summary stats on median AGB
#'
#' @param agb_stack SpatRaster with all data products
#' @param subset SpatVector to use for cropping and masking agb_stack
#' @param label character; label for this subset
#'
#' @return tibble
#' 
calc_med_summary <- function(agb_stack, subset) {
  agb_cropped <- crop(agb_stack, subset, mask = TRUE)
  agb_med <- median(agb_cropped, na.rm = TRUE)
  
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
    select(subset, product, everything())
  
}

