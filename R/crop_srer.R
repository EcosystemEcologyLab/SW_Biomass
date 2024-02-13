crop_srer <- function(agb_stack, srer_dir) {
  srer_vect <-
    vect(srer_dir) |> 
    project(agb_stack)
  crop(agb_stack, srer_vect, mask = TRUE)
}