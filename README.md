# AZ Carbon Stores Data Comparison


<!-- README.md is generated from README.qmd. Please edit that file -->
<!-- badges: start -->

[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)

<!-- badges: end -->

This is a research compendium for work in progress comparing estimates
of above-ground biomass in Arizona from different data products. This is
a collaboration between [CCT-Data
Science](https://datascience.cct.arizona.edu/) and the [David Moore
lab](https://djpmoore.tumblr.com/home) at University of Arizona.

## Reproducibility

<!--
### `renv`
&#10;This project uses [`renv`](https://rstudio.github.io/renv/articles/renv.html) for package management.
When opening this repo as an RStudio Project for the first time, `renv` should automatically install itself and prompt you to run `renv::restore()` to install all package dependencies.
-->

### `targets`

This project uses the [`targets`
package](https://docs.ropensci.org/targets/) for workflow management.
Run `targets::tar_make()` from the console to run the workflow and
reproduce all results. The graph below shows the workflow:

Warning message: package ‘tarchetypes’ was built under R version 4.3.2

``` mermaid
graph LR
  style Legend fill:#FFFFFF00,stroke:#000000;
  style Graph fill:#FFFFFF00,stroke:#000000;
  subgraph Legend
    direction LR
    x7420bd9270f8d27d([""Up to date""]):::uptodate --- x0a52b03877696646([""Outdated""]):::outdated
    x0a52b03877696646([""Outdated""]):::outdated --- xa8565c104d8f0705([""Dispatched""]):::dispatched
    xa8565c104d8f0705([""Dispatched""]):::dispatched --- xbf4603d6c2c2ad6b([""Stem""]):::none
    xbf4603d6c2c2ad6b([""Stem""]):::none --- x70a5fa6bea6f298d[""Pattern""]:::none
  end
  subgraph Graph
    direction LR
    x1194ca8b71ccd0e1(["agb_df"]):::uptodate --> xa9c8870bcb5985fd["scatter_plots"]:::uptodate
    xa5177effe50f87b0(["plot_comparisons"]):::uptodate --> xa9c8870bcb5985fd["scatter_plots"]:::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x1194ca8b71ccd0e1(["agb_df"]):::uptodate
    x9f7f8cade5fecf35(["esa_agb"]):::uptodate --> x7ff1622cd5d030f8(["ltgnn_agb"]):::uptodate
    xc968c07864940097(["ltgnn_dir"]):::uptodate --> x7ff1622cd5d030f8(["ltgnn_agb"]):::uptodate
    x10672e980111f5c2(["chopping_agb"]):::uptodate --> x74a8a38fc5a3e271(["agb_stack"]):::uptodate
    x9f7f8cade5fecf35(["esa_agb"]):::uptodate --> x74a8a38fc5a3e271(["agb_stack"]):::uptodate
    x5bee436f312cca80(["gedi_agb"]):::uptodate --> x74a8a38fc5a3e271(["agb_stack"]):::uptodate
    xe4f3f2f15e724def(["liu_agb"]):::uptodate --> x74a8a38fc5a3e271(["agb_stack"]):::uptodate
    x7ff1622cd5d030f8(["ltgnn_agb"]):::uptodate --> x74a8a38fc5a3e271(["agb_stack"]):::uptodate
    xb420f92ea294cb0b(["menlove_agb"]):::uptodate --> x74a8a38fc5a3e271(["agb_stack"]):::uptodate
    x6bb719b45bfee760(["xu_agb"]):::uptodate --> x74a8a38fc5a3e271(["agb_stack"]):::uptodate
    x9f7f8cade5fecf35(["esa_agb"]):::uptodate --> xe4f3f2f15e724def(["liu_agb"]):::uptodate
    x26d0dae1bf6fcb39(["liu_file"]):::uptodate --> xe4f3f2f15e724def(["liu_agb"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> xd959ad20dd7fd009(["agb_map"]):::outdated
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x7dce032f25b5c564(["sd_map"]):::uptodate
    x1194ca8b71ccd0e1(["agb_df"]):::uptodate --> xa5177effe50f87b0(["plot_comparisons"]):::uptodate
    x9f7f8cade5fecf35(["esa_agb"]):::uptodate --> x5bee436f312cca80(["gedi_agb"]):::uptodate
    x8d7fb25f1e16bc4f(["gedi_file"]):::uptodate --> x5bee436f312cca80(["gedi_agb"]):::uptodate
    xa9c8870bcb5985fd["scatter_plots"]:::uptodate --> x0ed052f6c2f4c6d2(["zip_scatter_plots"]):::outdated
    x9f7f8cade5fecf35(["esa_agb"]):::uptodate --> xb420f92ea294cb0b(["menlove_agb"]):::uptodate
    x5086af9665941a9e(["menlove_dir"]):::uptodate --> xb420f92ea294cb0b(["menlove_agb"]):::uptodate
    x9f7f8cade5fecf35(["esa_agb"]):::uptodate --> x5688b5ef6bcea6f9(["rap_agb"]):::uptodate
    x9889d33e942dc03b(["rap_file"]):::uptodate --> x5688b5ef6bcea6f9(["rap_agb"]):::uptodate
    x80cf9d1bb79c21e3(["chopping_file"]):::uptodate --> x10672e980111f5c2(["chopping_agb"]):::uptodate
    x9f7f8cade5fecf35(["esa_agb"]):::uptodate --> x10672e980111f5c2(["chopping_agb"]):::uptodate
    x1194ca8b71ccd0e1(["agb_df"]):::uptodate --> x13774cf4f2cc9b83(["ridge_plot"]):::uptodate
    x9f7f8cade5fecf35(["esa_agb"]):::uptodate --> x6bb719b45bfee760(["xu_agb"]):::uptodate
    x39b0a131ab7dd2d0(["xu_file"]):::uptodate --> x6bb719b45bfee760(["xu_agb"]):::uptodate
    xb91305eee1f5b0b5(["esa_dir"]):::uptodate --> x9f7f8cade5fecf35(["esa_agb"]):::uptodate
    x1194ca8b71ccd0e1(["agb_df"]):::uptodate --> xfe73ce9654aaf612(["violin_plot"]):::uptodate
    x6e52cb0f1668cc22(["readme"]):::dispatched --> x6e52cb0f1668cc22(["readme"]):::dispatched
    xe0fba61fbc506510(["report"]):::uptodate --> xe0fba61fbc506510(["report"]):::uptodate
  end
  classDef uptodate stroke:#000000,color:#ffffff,fill:#354823;
  classDef outdated stroke:#000000,color:#000000,fill:#78B7C5;
  classDef dispatched stroke:#000000,color:#000000,fill:#DC863B;
  classDef none stroke:#000000,color:#000000,fill:#94a4ac;
  linkStyle 0 stroke-width:0px;
  linkStyle 1 stroke-width:0px;
  linkStyle 2 stroke-width:0px;
  linkStyle 3 stroke-width:0px;
  linkStyle 35 stroke-width:0px;
  linkStyle 36 stroke-width:0px;
```

## File structure

``` r
fs::dir_tree(recurse = 1)
```

    .
    ├── LICENSE
    ├── R
    │   ├── get_esa_crs.R
    │   ├── make_az_sf.R
    │   ├── plot_agb_map.R
    │   ├── plot_agb_ridges.R
    │   ├── plot_scatter.R
    │   ├── plot_sd_map.R
    │   ├── plot_violin.R
    │   ├── project_to_esa.R
    │   ├── read_clean_chopping.R
    │   ├── read_clean_esa.R
    │   ├── read_clean_gedi.R
    │   ├── read_clean_liu.R
    │   ├── read_clean_lt_gnn.R
    │   ├── read_clean_menlove.R
    │   ├── read_clean_rap.R
    │   ├── read_clean_xu.R
    │   └── trim_image.R
    ├── README.md
    ├── README.qmd
    ├── README.rmarkdown
    ├── SW_Biomass.Rproj
    ├── _targets
    │   ├── meta
    │   ├── objects
    │   └── user
    ├── _targets.R
    ├── data
    │   ├── rasters
    │   └── shapefiles
    ├── docs
    │   ├── _extensions
    │   ├── fig
    │   ├── report.html
    │   ├── report.qmd
    │   └── report_files
    ├── notes
    │   ├── improve ridges.R
    │   ├── kernel_estimation.R
    │   ├── mosaic_tiles.R
    │   ├── pointdensity_plots.R
    │   └── violin_plots.R
    ├── run.R
    ├── run.sh
    └── scatter.zip

- `R/` contains functions used in the `targets` pipeline.
- `_targets` is generated by `targets::tar_make()` and only the metadata
  of the targets pipeline is on GitHub.
- `_targets.R` defines a `targets` workflow
  <!-- -   `_targets_packages.R` is generated by `targets::tar_renv()` -->
- `data/rasters` is where data files for each of the data products
  should be placed in order to reproduce this workflow. More detailed
  instructions on what files are there TBD.
- `data/shapefiles` currently unused in workflow.
- `docs/` contains output figures and reports that are rendered.
- `notes/` contains scripts with “sketches” about how to do things
  <!-- -   `renv/` and `renv.lock` are necessary for the `renv` package to work (see above) -->
- `run.R` is for conveniently running `tar_make()` as a background job.
  Created by `targets::use_targets()`
