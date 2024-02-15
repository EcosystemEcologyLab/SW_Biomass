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
  packages = c("ncdf4", "terra", "fs", "purrr", "units", "tidyterra", "ggplot2", "sf", "maps", "tidyr", "dplyr", "stringr", "stars", "magick", "ggridges", "ggrastr", "svglite", "ggtext", "ggthemes", "KernSmooth", "patchwork"), 
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

# terra objects can't be serialized to .rds files.  This is a custom format to
# save them as geotiffs and read them back in as SpatRasters.  Discussion here:
# https://github.com/ropensci/targets/discussions/1213
format_geotiff <- tar_format(
  read = function(path) terra::rast(path),
  write = function(object, path) terra::writeRaster(x = object, filename = path, filetype = "GTiff", overwrite = TRUE),
  marshal = function(object) terra::wrap(object),
  unmarshal = function(object) terra::unwrap(object)
)

tar_plan(
  # Read and harmonize 2010 AGB data products ------------
  tar_file(esa_dir, "data/rasters/ESA_CCI/"),
  tar_target(esa_agb, read_clean_esa(esa_dir), format = format_geotiff),
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
  tar_file(gedi_file, "data/rasters/GEDI_L4B_v2.1/data/GEDI04_B_MW019MW223_02_002_02_R01000M_MU.tif"),
  tar_target(gedi_agb, read_clean_gedi(gedi_file, esa_agb), format = format_geotiff),

  # Stack em! ---------------------------------------------------------------
  # I think this will be helpful for calculations and plotting?
  # Downside: will create a big file.
  
  #ignoring RAP for the moment
  tar_target(
    agb_stack,
    c(esa_agb, chopping_agb, liu_agb, xu_agb, ltgnn_agb, menlove_agb, gedi_agb),
    format = format_geotiff
  ),
  #TODO probably don't need this.  Just crop resulting maps instead of cropping before calculations
  tar_file(srer_dir, "data/shapefiles/srerboundary/"),
  tar_target(srer_stack, crop_srer(agb_stack, srer_dir), format = format_geotiff),
  
  # Plots -------------------------------------------------------------------
  # Maps faceted by data product
  tar_target(agb_map_png, plot_agb_map(agb_stack, downsample = TRUE), format = "file"),
  tar_target(agb_map_pdf, plot_agb_map(agb_stack, downsample = TRUE, filename = "map_agb.pdf"), format = "file"),

  # Maps of median across products
  tar_target(median_map_png, plot_median_map(agb_stack, downsample = FALSE, height = 2),
             format = "file"),
  tar_target(median_map_pdf, plot_median_map(agb_stack, downsample = FALSE, filename = "map_median.pdf", height = 2), 
             format = "file"),
  
  # Maps of SD across products
  tar_target(sd_map_png, plot_sd_map(agb_stack, downsample = FALSE, height = 2),
             format = "file"),
  tar_target(sd_map_pdf, plot_sd_map(agb_stack, downsample = FALSE, filename = "map_sd.pdf", height = 2), 
             format = "file"),
  
  # Convert to wide df.  Slow operation, so this saves time for plots that use a tibble
  tar_target(agb_df, as_tibble(as.data.frame(agb_stack))),
  
  # Ridge density plots
  tar_target(ridge_plot, plot_agb_ridges(agb_df)),
  tar_target(ridge_plot2, plot_agb_ridges(agb_df, est_separate = TRUE)),
  tar_target(ridge_plot_png, 
             ggsave("docs/fig/agb_ridge.png", ridge_plot, height = 2),
             format = "file"),
  tar_target(ridge_plot_pdf, 
             ggsave("docs/fig/agb_ridge.pdf", ridge_plot, height = 2, useDingbats = FALSE),
             format = "file"),
  tar_target(ridge_plot2_png, 
             ggsave("docs/fig/agb_ridge2.png", ridge_plot2, height = 2),
             format = "file"),
  tar_target(ridge_plot2_pdf, 
             ggsave("docs/fig/agb_ridge2.pdf", ridge_plot2, height = 2, useDingbats = FALSE),
             format = "file"),
  
  
  # Scatter plots against ESA
  tar_target(plot_comparisons, colnames(agb_df)[colnames(agb_df)!="ESA CCI"]),
  tar_target(
    scatter_plots,
    plot_scatter(
      agb_df,
      comparison = plot_comparisons,
      height = 2,
      width = 2
    ),
    pattern = map(plot_comparisons),
    format = "file"
  ), 
  tar_target(zip_scatter_plots, zip_plots(scatter_plots, "docs/fig/scatter.zip"), format = "file"), 
  
  # Render docs -------------------------------------------------------------
  #report
  tar_quarto(report, "docs/report.qmd", extra_files = fs::dir_ls("docs/fig/", glob = "*.png")),
  
  #README
  tar_quarto(readme, "README.qmd", cue = tar_cue(mode = "always"))
)
