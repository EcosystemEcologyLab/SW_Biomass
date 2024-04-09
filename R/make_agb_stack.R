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
    purrr::map(\(x) crop(x, vect(region), overwrite = TRUE) |> mask(vect(region)))
  
  #use method = "near" for low res dataset like Liu et al.
  rast_proj <- rast_cropped |> 
    purrr::map(\(x) {
      method <- ifelse(names(x) == "Liu et al.", "near", "bilinear")
      if (names(x) != "ESA CCI") { #don't project esa to esa to save time
        project(x, rast_cropped[[1]], method = method, threads = 4)
      } else {
        x
      }
      
    })
  
  rast_stack <- rast(rast_proj)
  varnames(rast_stack) <- purrr::map_chr(rast_list, varnames) #not sure if this is best, but whatever
  #return
  rast_stack
}