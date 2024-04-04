# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes)
library(geotargets)
library(tidyr)
library(fs)
library(quarto)

#Debug s3 bucket issues
# options(paws.log_level = 4L, paws.log_file = "paws_log.txt")

# Set target options:
tar_option_set(
  # packages that your targets need to run
  packages = c("ncdf4", "terra", "fs", "purrr", "units", "tidyterra", "ggplot2", "sf", "maps", "tidyr", "dplyr", "stringr", "stars", "magick", "ggridges", "ggrastr", "svglite", "ggtext", "ggthemes", "KernSmooth", "patchwork", "tibble"), 
  #
  # For distributed computing in tar_make(), supply a {crew} controller
  # as discussed at https://books.ropensci.org/targets/crew.html.
  # Choose a controller that suits your needs. For example, the following
  # sets a controller that scales up to a maximum of two workers
  # which run as local R processes. Each worker launches when there is work
  # to do and exits if 60 seconds pass with no tasks to run.
  #
  # controller = crew::crew_controller_local(workers = 2, seconds_idle = 60),
  
  # Use s3 bucket for targets store
  # repository = "aws", #comment out or change to "local" to store targets locally on disk
  ## Jetstream2 bucket:
  # resources = tar_resources(
  #   aws = tar_resources_aws(
  #     bucket = "test123456", #TODO: Maybe create a new bucket with Julian's help eventually
  #     prefix = "carbon_stores",
  #     endpoint = "https://js2.jetstream-cloud.org:8001",
  #     max_tries = 10
  #   )
  # )
  ## Wasabi bucket:
  # resources = tar_resources(
  #   aws = tar_resources_aws(
  #     bucket = "targets-test",
  #     prefix = "carbon_stores",
  #     endpoint = "https://s3.us-central-1.wasabisys.com"
  #   )
  # )
)

# Run the R scripts in the R/ folder with your custom functions:
tar_source()
# source("other_functions.R") # Source other scripts as needed.

tar_plan(
  # Read shapefiles ---------------------------------------
  tar_file(neon_file, "data/shapefiles/Field_Sampling_Boundaries_2020/"),
  tar_terra_vect(neon_core, vect(neon_file) |> filter(siteType == "Core Terrestrial")),
  conus = maps::map("usa", plot = FALSE, fill = TRUE) |> st_as_sf(),
  ca_az = make_ca_az_sf(),
  
  # Read and harmonize 2010 AGB data products ------------
  # Intially cropped to CONUS when read in, and transformed to common CRS (but
  # not common resolution).
  # By default, tar_file() with repository="aws" uploads the files to the s3
  # bucket.  Since they're already on an attached volume on Jetstream2, I use
  # repository = "local" to prevent this. Logic above changes the path to the
  # correct place depending on where this is run.
  tar_file(esa_files, dir_ls("data/rasters/ESA_CCI/", glob = "*.tif*"), repository = "local"),
  tar_terra_rast(esa_agb, read_clean_esa(esa_files, conus)),
  tar_file(chopping_file, "data/rasters/Chopping/MISR_agb_estimates_20002021.tif", repository = "local"),
  tar_terra_rast(chopping_agb, read_clean_chopping(chopping_file, esa_agb, conus)),
  tar_file(liu_file, "data/rasters/Liu/Aboveground_Carbon_1993_2012.nc", repository = "local"),
  tar_terra_rast(liu_agb, read_clean_liu(liu_file, esa_agb, conus)),
  tar_file(xu_file, "data/rasters/Xu/test10a_cd_ab_pred_corr_2000_2019_v2.tif", repository = "local"),
  tar_terra_rast(xu_agb, read_clean_xu(xu_file, esa_agb, conus)),
  # tar_file(rap_file, "data/rasters/RAP/vegetation-biomass-v3-2010.tif"),
  # tar_terra_rast(rap_agb, read_clean_rap(rap_file, esa_agb, conus)),
  tar_file(ltgnn_files, fs::dir_ls("data/rasters/LT_GNN", glob = "*.zip"), repository = "local"),
  tar_terra_rast(ltgnn_agb, read_clean_lt_gnn(ltgnn_files, esa_agb, conus)),
  tar_file(menlove_dir, "data/rasters/Menlove/data/", repository = "local"), 
  tar_terra_rast(menlove_agb, read_clean_menlove(menlove_dir, esa_agb, conus)),
  tar_file(gedi_file, "data/rasters/GEDI_L4B_v2.1/data/GEDI04_B_MW019MW223_02_002_02_R01000M_MU.tif",
           repository = "local"),
  tar_terra_rast(gedi_agb, read_clean_gedi(gedi_file, esa_agb, conus)),


  # Extract data for every NEON & Ameriflux site ----------------------------
  #TODO: Create vect for NEON sites (polygons)
  #TODO: Create vect for Ameriflux sites (points -> polygons??)
  #TODO: Extract AGB from each product for each vect & get mean for each site, export as CSV
    
  
  # Stack em! ---------------------------------------------------------------
  # Project to common resolution, crop to CA and AZ, and create a multi-layer raster stack

  #ignoring RAP for the moment
  tar_terra_rast(
    agb_stack,
    make_agb_stack(chopping_agb, liu_agb, xu_agb, ltgnn_agb, menlove_agb, gedi_agb,
                   esa = esa_agb, region = ca_az)
  ),
  
  # Plots -------------------------------------------------------------------
  tar_file(srer_dir, "data/shapefiles/srerboundary/", repository = "local"),
  tar_file(pima_dir, "data/shapefiles/Pima_County_Boundary/", repository = "local"),
  
  # Dynamic branching example.  Might be more useful when there are a lot more subsets
  # tar_target(subsets,
  #            make_shape_list(crs = st_crs(agb_stack), srer_dir = srer_dir, pima_dir = pima_dir),
  #            iteration = "list"),
  # tar_target(test, ext(crop(agb_stack, subsets))[1], pattern = map(subsets)),
  
  # Use static branching to make all the maps of all the subsets
  az = maps::map("state", "arizona", plot = FALSE, fill = TRUE) |> 
    st_as_sf() |> 
    st_transform(st_crs(agb_stack)) |> 
    mutate(subset = "AZ"),
  ca = maps::map("state", "california", plot = FALSE, fill = TRUE) |> 
    st_as_sf() |> 
    st_transform(st_crs(agb_stack)) |> 
    mutate(subset = "CA"),
  srer = st_read(srer_dir) |> 
    st_transform(st_crs(agb_stack)) |> 
    mutate(subset = "SRER"),
  pima = st_read(pima_dir) |> 
    st_transform(st_crs(agb_stack)) |> 
    mutate(subset = "Pima County"),
  
  tar_map(
    values = tidyr::expand_grid(
      subset = rlang::syms(c("az", "ca", "srer", "pima")),
      file_ext = c("png", "pdf")
    ),
    # Maps faceted by data product
    tar_target(
      agb_map, 
      plot_agb_map(agb_stack, subset, downsample = TRUE, ext = file_ext), 
      format = "file"
    ),
    # Maps of median AGB across products
    tar_target(
      median_map,
      plot_median_map(agb_stack, subset, downsample = FALSE, ext = file_ext, height = 2),
      format = "file"
    ),
    # # Maps of SD across products
    tar_target(
      sd_map,
      plot_sd_map(agb_stack, subset, downsample = FALSE, ext = file_ext, height = 2),
      format = "file"
    )
  ),
  
  # Density ridge plots
  #TODO this would be faster if the plots were made once and saved twice.  Don't have the same limitations as geom_spatraster where you can't save the resulting ggplot objects as targets.
  tar_map(
    values = list(ext = c("png", "pdf")),
    
    tar_target(
      ridge_az,
      plot_agb_ridges(agb_stack, az,
                      filename = paste("agb_density_az", ext, sep = "."),
                      height = 2, width = 4.2),
      format = "file"
    ),
    tar_target(
      ridge_ca,
      plot_agb_ridges(agb_stack, ca,
                      break_x = 50,
                      filename = paste("agb_density_ca", ext, sep = "."),
                      height = 2, width = 4.2),
      format = "file"
    ),
    tar_target(
      ridge_pima,
      plot_agb_ridges(agb_stack, pima,
                      break_x = c(30, 50),
                      filename = paste("agb_density_pima", ext, sep = "."),
                      height = 2, width = 4.2),
      format = "file"
    ),
    tar_target(
      ridge_srer,
      plot_agb_ridges(agb_stack, srer,
                      break_plot = FALSE,
                      filename = paste("agb_density_srer", ext, sep = "."),
                      height = 2, width = 4.2),
      format = "file"
    )
  ),
  
  # Summary statistics
  tar_target(subsets,
             list("AZ" = az, "CA" = ca, "SRER" = srer, "Pima County" = pima),
             iteration = "list"),
  tar_target(
    summary_stats,
    calc_summary(agb_stack, subsets),
    pattern = map(subsets)
  ),
  
  # Scatter plots against ESA, just for Arizona for now
  tar_target(agb_df_az, as_tibble(as.data.frame(crop(agb_stack, az, mask = TRUE)))),
  tar_target(plot_comparisons, colnames(agb_df_az)[colnames(agb_df_az)!="ESA CCI"]),
  tar_target(
    scatter_plots,
    plot_scatter(
      agb_df_az,
      comparison = plot_comparisons,
      height = 2,
      width = 2
    ),
    pattern = map(plot_comparisons),
    format = "file"
  ),
  tar_target(zip_scatter_plots, zip_plots(scatter_plots, "docs/fig/scatter.zip"), format = "file"),

  # # Render docs -------------------------------------------------------------
  #report
  tar_quarto(report, "docs/report.qmd", working_directory = "docs"),

  #README
  tar_quarto(readme, "README.qmd", cue = tar_cue(mode = "always"))
)
