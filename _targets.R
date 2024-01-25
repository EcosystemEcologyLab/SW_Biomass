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
  packages = c("ncdf4", "terra", "fs", "purrr", "units"), # packages that your targets need to run
  # format = "qs",
  #
  # For distributed computing in tar_make(), supply a {crew} controller
  # as discussed at https://books.ropensci.org/targets/crew.html.
  # Choose a controller that suits your needs. For example, the following
  # sets a controller with 2 workers which will run as local R processes:
  #
  # controller = crew::crew_controller_local(workers = 3)
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

tar_plan(
  # Get shapefiles for spatial subsets ---------------

  tar_file(sw_box_file, "data/shapefiles/SW_Region_Box.shp"),
  tar_target(sw_box, vect(sw_box_file), format = format_terra),
  tar_file(gw_box_file, "data/shapefiles/Goldwater_Range_Box.shp"),
  tar_target(gw_box, vect(gw_box_file), format = format_terra),
  tar_file(nnss_box_file, "data/shapefiles/NNSS_Box.shp"),
  tar_target(nnss_box, vect(nnss_box_file), format = format_terra),
  tar_file(ws_box_file, "data/shapefiles/White_Sands_Box.shp"),
  tar_target(ws_box, vect(ws_box_file), format = format_terra),
  
  # Read 2010 AGB data products ------------
  tar_file(chopping_file, "data/rasters/Chopping/MISR_agb_estimates_20002021.tif"),
  tar_target(chopping_agb, read_clean_chopping(chopping_file), format = format_terra),
  tar_file(liu_file, "data/rasters/Liu/Aboveground_Carbon_1993_2012.nc"),
  tar_target(liu_agb, read_clean_liu(liu_file), format = format_terra),
  tar_files(esa_files, dir_ls("data/rasters/ESA_CCI/", glob = "*.tif")),
  tar_target(esa_agb, read_clean_esa(esa_files, sw_box), format = format_terra),
  tar_file(xu_file, "data/rasters/Xu/test10a_cd_ab_pred_corr_2000_2019_v2.tif"),
  tar_target(xu_agb, read_clean_xu(xu_file, sw_box), format = format_terra),
  tar_file(rap_file, "data/rasters/RAP/vegetation-biomass-v3-2010.tif"),
  tar_target(rap_agb, read_clean_rap(rap_file, sw_box), format = format_terra),
  
)
