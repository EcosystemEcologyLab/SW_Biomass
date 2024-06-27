# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes)
library(geotargets)
library(terra)
library(tidyr) #for expand_grid()
library(rlang) #for syms()
library(fs)
library(quarto)

#Debug s3 bucket issues
# options(paws.log_level = 4L, paws.log_file = "paws_log.txt")

# Set target options:
tar_option_set(
  # packages that your targets need to run
  packages = c("terra", "fs", "exactextractr", "purrr", "units", "tidyterra", "ggplot2", "sf", "maps", "tidyr", "dplyr", "stringr", "magick", "ggridges", "ggrastr", "svglite", "ggtext", "ggthemes", "KernSmooth", "patchwork", "tibble"), 
  controller = crew::crew_controller_local(workers = 2, seconds_idle = 60)
)

# Run the R scripts in the R/ folder with your custom functions:
tar_source()
# source("other_functions.R") # Source other scripts as needed.

inputs <- tar_plan(
  # create shapefiles for southwest
  tar_terra_vect(ca_az, get_ca_az()),
  tar_terra_vect(ca, get_ca()),
  tar_terra_vect(az, get_az()),
  tar_file(pima_file, "data/shapefiles/Pima_County_Boundary/"),
  tar_terra_vect(pima, terra::vect(pima_file)),
  tar_file(srer_file, "data/shapefiles/srerboundary/"),
  tar_terra_vect(srer, terra::vect(srer_file)),
  
  # Track raster files 
  tar_file(xu_file, "data/AGB_cleaned/xu/xu_2000-2029.tif"),
  tar_file(liu_file, "data/AGB_cleaned/liu/liu_1993-2012.tif"),
  tar_file(menlove_file, "data/AGB_cleaned/menlove/menlove_2009-2019.tif"),
  tar_file(gedi_file, "data/AGB_cleaned/gedi/gedi_2019-2023.tif"),
  tar_file(chopping_file, "data/AGB_cleaned/chopping/chopping_2000-2021.tif"),
  tar_file(esa_dir, "data/AGB_cleaned/esa_cci/"),
  tar_file(ltgnn_dir, "data/AGB_cleaned/lt_gnn/"),
  
  # Read in rasters (all layers for now)
  tar_terra_rast(xu_agb, read_agb(xu_file, ca_az)),
  tar_terra_rast(liu_agb, read_agb(liu_file, ca_az)),
  tar_terra_rast(menlove_agb, read_agb(menlove_file, ca_az)),
  tar_terra_rast(gedi_agb, read_agb(gedi_file, ca_az)),
  tar_terra_rast(chopping_agb, read_agb(chopping_file, ca_az)),
  tar_terra_rast(esa_agb, read_agb(esa_dir, ca_az)),
  tar_terra_rast(ltgnn_agb, read_agb(ltgnn_dir, ca_az))
)
# Get summary statistics for AZ, CA, Pima County, SRER
agb <- tar_plan(
  tar_map(
    values = tidyr::expand_grid(
      product = syms(c("xu_agb", "liu_agb", "menlove_agb", "gedi_agb", "chopping_agb", "esa_agb", "ltgnn_agb")),
      subset = syms(c("pima", "srer", "ca", "az"))
    ),
    tar_target(
      summary,
      summarize_agb(product, subset),
      storage = "worker",
      retrieval = "worker"
    )
  )
)

agb_summary <- tar_plan(
  tar_combine(
    agb_stats,
    agb, #refers to the above list of targets to combine
    command = dplyr::bind_rows(!!!.x)
  ),
  tar_target(
    agb_trend_plot,
    plot_agb_trend(agb_stats)
  )
  #TODO plot totals (sum column) over time for each subset
  #TODO export plots as .png
  #TODO export data as .csv
)

# Reproject just 2010 layer to common CRS
reproject <- tar_plan(
  tar_map( #for each product
    values = list(
      product = syms(c("esa_agb", "xu_agb", "liu_agb", "menlove_agb", "gedi_agb", "chopping_agb", "ltgnn_agb"))
    ),
    tar_terra_rast(
      common,
      project_to_esa(product, esa_agb),
      description = "Extract 2010, transform to common CRS & resolution",
      storage = "worker",
      retrieval = "worker"
    )
  )
)

stack <- tar_plan(
  # tar_combine( #need a geotargets version of this to work
  #   agb_stack,
  #   reproject, #refers to all the targets created above
  #   command = c(!!!.x),
  #   storage = "worker",
  #   retrieval = "worker"
  # ),
  tar_terra_rast(
    agb_stack,
    c(
      common_esa_agb,
      common_xu_agb,
      common_liu_agb, 
      common_menlove_agb,
      common_gedi_agb,
      common_chopping_agb,
      common_ltgnn_agb
    ),
    storage = "worker",
    retrieval = "worker"
  ),
  tar_terra_rast(
    sd_stack, #TODO is this a stack???
    terra::stdev(agb_stack, na.rm = TRUE),
    storage = "worker",
    retrieval = "worker"
  ),
  #TODO: add target for median across all products
)

sd <- tar_plan(
  tar_map( #for every subset...
    values = list(
      subset = syms(c("pima", "srer", "ca", "az"))
    ),
    #... do this target:
    tar_target(
      sd_summary,
      summarize_sd(sd_stack, subset),
      storage = "worker",
      retrieval = "worker"
    )
  )
)

sd_summary <- tar_plan(
  tar_combine(
    sd_stats,
    sd, #refers to the above list of targets to combine
    command = dplyr::bind_rows(!!!.x)
  ),
  #TODO: target to write out as .csv
)

#TODO: add `median` and `median_summary`

# # Plots -------------------------------------------------------------------
plots <- tar_plan(
  tar_map(
    values = tidyr::expand_grid(
      subset = rlang::syms(c("az", "ca", "srer", "pima")),
      file_ext = c("png", "pdf")
    ),
    #TODO shouldn't I just do this with the original rasters, not the re-projected rasters?
    # Maps faceted by data product 
    # tar_target(
    #   agb_map,
    #   plot_agb_map(agb_stack, subset, downsample = TRUE, ext = file_ext),
    #   format = "file"
    # ),
    # Maps of median AGB across products
    tar_target(
      median_map,
      plot_median_map(agb_stack, subset, downsample = FALSE, ext = file_ext, height = 2),
      format = "file",
      storage = "worker",
      retrieval = "worker"
    ),
    # # Maps of SD across products
    tar_target(
      sd_map,
      plot_sd_map(sd_stack, subset, downsample = FALSE, ext = file_ext, height = 2),
      format = "file",
      storage = "worker",
      retrieval = "worker"
    )
  ),
)


# Density ridge plots
#TODO this would be faster if the plots were made once and saved twice.  Don't have the same limitations as geom_spatraster where you can't save the resulting ggplot objects as targets.
# unfortunately can't really make these plots using the original rasters since some of the subsets only have 1 or 2 pixels, not a distribution of values.
density_plots <- tar_plan(
  tar_map(
    values = list(ext = "png"), #for prototyping
    # values = list(ext = c("png", "pdf")), #uncomment to produce publication quality figures
    
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
  )
)

# # Scatter plots against ESA, just for Arizona for now
scatter <- tar_plan(
  tar_target(agb_df_az, as_tibble(as.data.frame(crop(agb_stack, az, mask = TRUE, overwrite = TRUE)))),
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
  tar_target(zip_scatter_plots, zip_plots(scatter_plots, "docs/fig/scatter.zip"), format = "file")
)

# # # Render docs -------------------------------------------------------------
reports <- tar_plan(
  #report
  tar_quarto(report, "docs/report.qmd", working_directory = "docs"),
  
  #README
  tar_quarto(readme, "README.qmd", cue = tar_cue(mode = "always"))
)

list2(
  inputs,
  agb,
  agb_summary,
  reproject,
  stack,
  sd,
  sd_summary,
  plots,
  density_plots,
  scatter,
  reports
)
