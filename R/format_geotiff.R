# terra objects can't be serialized to .rds files.  This is a custom format to
# save them as geotiffs and read them back in as SpatRasters.  Discussion here:
# https://github.com/ropensci/targets/discussions/1213
format_geotiff <- tar_format(
  read = function(path) terra::rast(path),
  write = function(object, path) terra::writeRaster(x = object, filename = path, filetype = "GTiff", overwrite = TRUE),
  marshal = function(object) terra::wrap(object),
  unmarshal = function(object) terra::unwrap(object)
)