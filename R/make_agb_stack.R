# make_agb_stack <- function(..., region) {
#   #TODO project all products to the esa resolution using method = "near" (?)
#   stack <- c(...)
#   region <- st_transform(region, st_crs(stack))
#   stack |> crop(region, overwrite = TRUE) |> mask(vect(region))
# }

make_agb_stack <- function(..., esa, region) {
  rast_list <- list(esa, ...)
  region <- st_transform(region, crs = crs(esa))
  
  #crop first so projection is faster
  rast_cropped <- rast_list |> 
    purrr::map(\(x) crop(x, vect(region), overwrite = TRUE, mask = TRUE, extend = TRUE))
  
  rast_proj <- rast_cropped |> #this wastes some time by projecting esa to esa
    purrr::map(\(x) project(x, rast_cropped[[1]], threads = 4))
  
  rast_stack <- rast(rast_proj)
  varnames(rast_stack) <- purrr::map_chr(rast_list, varnames) #not sure if this is best, but whatever
  #return
  rast_stack
}