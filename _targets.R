# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes)
# library(qs)

# Set target options:
tar_option_set(
  # packages that your targets need to run
  packages = c("ncdf4", "terra", "fs", "purrr", "units", "tidyterra", "ggplot2", "sf", "maps", "tidyr", "dplyr", "stringr", "stars"), 
  # format = "qs",
  #
  # For distributed computing in tar_make(), supply a {crew} controller
  # as discussed at https://books.ropensci.org/targets/crew.html.
  # Choose a controller that suits your needs. For example, the following
  # sets a controller with 2 workers which will run as local R processes:
  #
  # controller = crew::crew_controller_local(workers = 3)
  #TODO: check if multiple workers is even faster.  It might not be because of the overhead of moving the geotiffs to and from parallel workers
)

# Run the R scripts in the R/ folder with your custom functions:
tar_source()
# source("other_functions.R") # Source other scripts as needed.

# terra objects can't be serialized without `wrap()`ing them.  This is a custom
# format for dealing with that.  NOTE: this breaks if the targets pipeline is
# run with more than 1 worker. Discussion on how to deal with this:
# https://github.com/ropensci/targets/discussions/1213
format_terra <- tar_format(
  read = function(path) terra::unwrap(readRDS(path)),
  write = function(object, path) saveRDS(object = terra::wrap(object), file = path)
  )

# This still doesn't work with multiple workers
format_geotiff <- tar_format(
  read = function(path) terra::rast(path),
  write = function(object, path) terra::writeRaster(x = object, filename = path, filetype = "GTiff", overwrite = TRUE),
  marshal = function(object) terra::wrap(object),
  unmarshal = function(object) terra::unwrap(object)
)

tar_plan(
  tar_target(esa_crs, get_esa_crs()),
  #TODO add a target for "data_dir" and modify other file targets to use it so can be more flexible in terms of where the data is placed (e.g. on an external drive).  E.g. fs::path(data_dir, "shapefiles", "SW_Region_Box_.shp")
  
  # Get polygon for cropping to AZ ---------------
  tar_target(az_sf, make_az_sf(esa_crs)),

  # Read and harmonize 2010 AGB data products ------------
  tar_file(esa_dir, "data/rasters/ESA_CCI/"),
  tar_target(esa_agb, read_clean_esa(esa_dir, az_sf), format = format_geotiff),
  tar_file(chopping_file, "data/rasters/Chopping/MISR_agb_estimates_20002021.tif"),
  tar_target(chopping_agb, read_clean_chopping(chopping_file, esa_agb), format = format_geotiff),
  tar_file(liu_file, "data/rasters/Liu/Aboveground_Carbon_1993_2012.nc"),
  tar_target(liu_agb, read_clean_liu(liu_file, esa_agb), format = format_geotiff),
  tar_file(xu_file, "data/rasters/Xu/test10a_cd_ab_pred_corr_2000_2019_v2.tif"),
  tar_target(xu_agb, read_clean_xu(xu_file, esa_agb), format = format_geotiff),
  tar_file(rap_file, "data/rasters/RAP/vegetation-biomass-v3-2010.tif"),
  tar_target(rap_agb, read_clean_rap(rap_file, esa_agb), format = format_geotiff),
  tar_file(ltgnn_dir, "data/rasters/LT_GNN/"),
  tar_target(ltgnn_agb, read_clean_lt_gnn(ltgnn_dir, esa_agb), format = format_geotiff),
  tar_file(menlove_dir, "data/rasters/Menlove/data/"),
  tar_target(menlove_agb, read_clean_menlove(menlove_dir, esa_agb), format = format_geotiff),

  # Stack em! ---------------------------------------------------------------
  # I think this will be helpful for calculations and plotting?
  # Downside: will create a big file.
  
  #ignoring RAP for the moment
  tar_target(
    agb_stack,
    c(esa_agb, chopping_agb, liu_agb, xu_agb, ltgnn_agb, menlove_agb),
    format = format_geotiff
  ),
  tar_target(agb_map, plot_agb_map(agb_stack, width = 7, height = 6), format = "file"),
  tar_target(sd_map, plot_sd_map(agb_stack), format = "file"),
  tar_target(violin_plot, plot_violin(agb_stack), format = "file"),
  
  #report
  tar_quarto(report, "report.qmd", extra_files = "fig/")
)
