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

``` mermaid
graph LR
  style Legend fill:#FFFFFF00,stroke:#000000;
  style Graph fill:#FFFFFF00,stroke:#000000;
  subgraph Legend
    direction LR
    x7420bd9270f8d27d([""Up to date""]):::uptodate --- xa8565c104d8f0705([""Dispatched""]):::dispatched
    xa8565c104d8f0705([""Dispatched""]):::dispatched --- x0a52b03877696646([""Outdated""]):::outdated
    x0a52b03877696646([""Outdated""]):::outdated --- xbf4603d6c2c2ad6b([""Stem""]):::none
    xbf4603d6c2c2ad6b([""Stem""]):::none --- x70a5fa6bea6f298d[""Pattern""]:::none
  end
  subgraph Graph
    direction LR
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x7fb455d668686b01(["az"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x3b1c211818931399(["median_map_srer_SRER_pdf"]):::uptodate
    xe3a3f405d949368a(["srer"]):::uptodate --> x3b1c211818931399(["median_map_srer_SRER_pdf"]):::uptodate
    x9f7f8cade5fecf35(["esa_agb"]):::uptodate --> x7ff1622cd5d030f8(["ltgnn_agb"]):::uptodate
    xc968c07864940097(["ltgnn_dir"]):::uptodate --> x7ff1622cd5d030f8(["ltgnn_agb"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x5b76edab95fa1a87(["ridge_az_pdf"]):::uptodate
    x7fb455d668686b01(["az"]):::uptodate --> x5b76edab95fa1a87(["ridge_az_pdf"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x0e4394c89ab817da(["ca"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> xe5fe7e4eb140dcfa(["pima"]):::uptodate
    x87c08b8965ac44dd(["pima_dir"]):::uptodate --> xe5fe7e4eb140dcfa(["pima"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> xcdfed8c5f56ef55d(["sd_map_pima_PimaCounty_png"]):::uptodate
    xe5fe7e4eb140dcfa(["pima"]):::uptodate --> xcdfed8c5f56ef55d(["sd_map_pima_PimaCounty_png"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x41a8565148b4f096(["median_map_az_AZ_png"]):::uptodate
    x7fb455d668686b01(["az"]):::uptodate --> x41a8565148b4f096(["median_map_az_AZ_png"]):::uptodate
    x9f7f8cade5fecf35(["esa_agb"]):::uptodate --> xe4f3f2f15e724def(["liu_agb"]):::uptodate
    x26d0dae1bf6fcb39(["liu_file"]):::uptodate --> xe4f3f2f15e724def(["liu_agb"]):::uptodate
    xb91305eee1f5b0b5(["esa_dir"]):::uptodate --> x9f7f8cade5fecf35(["esa_agb"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x1416f223f8b9a095(["sd_map_pima_PimaCounty_pdf"]):::uptodate
    xe5fe7e4eb140dcfa(["pima"]):::uptodate --> x1416f223f8b9a095(["sd_map_pima_PimaCounty_pdf"]):::uptodate
    x7abafd87efa13647(["agb_df_az"]):::uptodate --> xa5177effe50f87b0(["plot_comparisons"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x2cbb06fb1d8dfb74(["median_map_ca_CA_png"]):::uptodate
    x0e4394c89ab817da(["ca"]):::uptodate --> x2cbb06fb1d8dfb74(["median_map_ca_CA_png"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x73c36959826f3086(["median_map_ca_CA_pdf"]):::uptodate
    x0e4394c89ab817da(["ca"]):::uptodate --> x73c36959826f3086(["median_map_ca_CA_pdf"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x889e103f0ca22367(["ridge_pima_pdf"]):::uptodate
    xe5fe7e4eb140dcfa(["pima"]):::uptodate --> x889e103f0ca22367(["ridge_pima_pdf"]):::uptodate
    x9f7f8cade5fecf35(["esa_agb"]):::uptodate --> x5688b5ef6bcea6f9(["rap_agb"]):::uptodate
    x9889d33e942dc03b(["rap_file"]):::uptodate --> x5688b5ef6bcea6f9(["rap_agb"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x0faa310f699b45a5["summary_stats"]:::uptodate
    x5cbd07d8ce48e961(["subsets"]):::uptodate --> x0faa310f699b45a5["summary_stats"]:::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x5488b960ef0cdfa9(["median_map_srer_SRER_png"]):::uptodate
    xe3a3f405d949368a(["srer"]):::uptodate --> x5488b960ef0cdfa9(["median_map_srer_SRER_png"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x60c69b5a4aa33a2c(["ridge_ca_png"]):::uptodate
    x0e4394c89ab817da(["ca"]):::uptodate --> x60c69b5a4aa33a2c(["ridge_ca_png"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x7f0544e7f00416c9(["sd_map_az_AZ_pdf"]):::uptodate
    x7fb455d668686b01(["az"]):::uptodate --> x7f0544e7f00416c9(["sd_map_az_AZ_pdf"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> xcaaa00b34d60beaf(["agb_map_az_AZ_pdf"]):::uptodate
    x7fb455d668686b01(["az"]):::uptodate --> xcaaa00b34d60beaf(["agb_map_az_AZ_pdf"]):::uptodate
    x80cf9d1bb79c21e3(["chopping_file"]):::uptodate --> x10672e980111f5c2(["chopping_agb"]):::uptodate
    x9f7f8cade5fecf35(["esa_agb"]):::uptodate --> x10672e980111f5c2(["chopping_agb"]):::uptodate
    x9f7f8cade5fecf35(["esa_agb"]):::uptodate --> x5bee436f312cca80(["gedi_agb"]):::uptodate
    x8d7fb25f1e16bc4f(["gedi_file"]):::uptodate --> x5bee436f312cca80(["gedi_agb"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> xccaa194bef539bce(["sd_map_srer_SRER_pdf"]):::uptodate
    xe3a3f405d949368a(["srer"]):::uptodate --> xccaa194bef539bce(["sd_map_srer_SRER_pdf"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> xb8f1367168074e6c(["ridge_az_png"]):::uptodate
    x7fb455d668686b01(["az"]):::uptodate --> xb8f1367168074e6c(["ridge_az_png"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> xfad216b51a6a5430(["agb_map_pima_PimaCounty_pdf"]):::uptodate
    xe5fe7e4eb140dcfa(["pima"]):::uptodate --> xfad216b51a6a5430(["agb_map_pima_PimaCounty_pdf"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x9902cde52e024266(["agb_map_srer_SRER_png"]):::uptodate
    xe3a3f405d949368a(["srer"]):::uptodate --> x9902cde52e024266(["agb_map_srer_SRER_png"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x35dcdfe6cacbee43(["agb_map_srer_SRER_pdf"]):::uptodate
    xe3a3f405d949368a(["srer"]):::uptodate --> x35dcdfe6cacbee43(["agb_map_srer_SRER_pdf"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x79e9ba0c706f57ec(["median_map_pima_PimaCounty_pdf"]):::uptodate
    xe5fe7e4eb140dcfa(["pima"]):::uptodate --> x79e9ba0c706f57ec(["median_map_pima_PimaCounty_pdf"]):::uptodate
    x0faa310f699b45a5["summary_stats"]:::uptodate --> xe0fba61fbc506510(["report"]):::outdated
    x9f7f8cade5fecf35(["esa_agb"]):::uptodate --> xb420f92ea294cb0b(["menlove_agb"]):::uptodate
    x5086af9665941a9e(["menlove_dir"]):::uptodate --> xb420f92ea294cb0b(["menlove_agb"]):::uptodate
    x7abafd87efa13647(["agb_df_az"]):::uptodate --> xa9c8870bcb5985fd["scatter_plots"]:::uptodate
    xa5177effe50f87b0(["plot_comparisons"]):::uptodate --> xa9c8870bcb5985fd["scatter_plots"]:::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x7abafd87efa13647(["agb_df_az"]):::uptodate
    x7fb455d668686b01(["az"]):::uptodate --> x7abafd87efa13647(["agb_df_az"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x377c593b0eb4d7e4(["ridge_srer_png"]):::uptodate
    xe3a3f405d949368a(["srer"]):::uptodate --> x377c593b0eb4d7e4(["ridge_srer_png"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x31a8f9ae377f5b5a(["ridge_srer_pdf"]):::uptodate
    xe3a3f405d949368a(["srer"]):::uptodate --> x31a8f9ae377f5b5a(["ridge_srer_pdf"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> xe3a3f405d949368a(["srer"]):::uptodate
    xc7f156126aa49133(["srer_dir"]):::uptodate --> xe3a3f405d949368a(["srer"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x8a75984fde519ee9(["median_map_az_AZ_pdf"]):::uptodate
    x7fb455d668686b01(["az"]):::uptodate --> x8a75984fde519ee9(["median_map_az_AZ_pdf"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> xce3e4c36a0bb379d(["sd_map_srer_SRER_png"]):::uptodate
    xe3a3f405d949368a(["srer"]):::uptodate --> xce3e4c36a0bb379d(["sd_map_srer_SRER_png"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> xabd1fbf9b5277ac6(["sd_map_az_AZ_png"]):::uptodate
    x7fb455d668686b01(["az"]):::uptodate --> xabd1fbf9b5277ac6(["sd_map_az_AZ_png"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> xbb048d8d400e8965(["agb_map_az_AZ_png"]):::uptodate
    x7fb455d668686b01(["az"]):::uptodate --> xbb048d8d400e8965(["agb_map_az_AZ_png"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x0ecdde11d08ced50(["agb_map_pima_PimaCounty_png"]):::uptodate
    xe5fe7e4eb140dcfa(["pima"]):::uptodate --> x0ecdde11d08ced50(["agb_map_pima_PimaCounty_png"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x74d945a3c8287e0c(["sd_map_ca_CA_pdf"]):::uptodate
    x0e4394c89ab817da(["ca"]):::uptodate --> x74d945a3c8287e0c(["sd_map_ca_CA_pdf"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x5a05f0d4887baa80(["agb_map_ca_CA_pdf"]):::uptodate
    x0e4394c89ab817da(["ca"]):::uptodate --> x5a05f0d4887baa80(["agb_map_ca_CA_pdf"]):::uptodate
    x7fb455d668686b01(["az"]):::uptodate --> x5cbd07d8ce48e961(["subsets"]):::uptodate
    x0e4394c89ab817da(["ca"]):::uptodate --> x5cbd07d8ce48e961(["subsets"]):::uptodate
    xe5fe7e4eb140dcfa(["pima"]):::uptodate --> x5cbd07d8ce48e961(["subsets"]):::uptodate
    xe3a3f405d949368a(["srer"]):::uptodate --> x5cbd07d8ce48e961(["subsets"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x853e79625694a360(["ridge_pima_png"]):::uptodate
    xe5fe7e4eb140dcfa(["pima"]):::uptodate --> x853e79625694a360(["ridge_pima_png"]):::uptodate
    xa9c8870bcb5985fd["scatter_plots"]:::uptodate --> x0ed052f6c2f4c6d2(["zip_scatter_plots"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> xba49192fd3f5570a(["median_map_pima_PimaCounty_png"]):::uptodate
    xe5fe7e4eb140dcfa(["pima"]):::uptodate --> xba49192fd3f5570a(["median_map_pima_PimaCounty_png"]):::uptodate
    x10672e980111f5c2(["chopping_agb"]):::uptodate --> x74a8a38fc5a3e271(["agb_stack"]):::uptodate
    x9f7f8cade5fecf35(["esa_agb"]):::uptodate --> x74a8a38fc5a3e271(["agb_stack"]):::uptodate
    x5bee436f312cca80(["gedi_agb"]):::uptodate --> x74a8a38fc5a3e271(["agb_stack"]):::uptodate
    xe4f3f2f15e724def(["liu_agb"]):::uptodate --> x74a8a38fc5a3e271(["agb_stack"]):::uptodate
    x7ff1622cd5d030f8(["ltgnn_agb"]):::uptodate --> x74a8a38fc5a3e271(["agb_stack"]):::uptodate
    xb420f92ea294cb0b(["menlove_agb"]):::uptodate --> x74a8a38fc5a3e271(["agb_stack"]):::uptodate
    x6bb719b45bfee760(["xu_agb"]):::uptodate --> x74a8a38fc5a3e271(["agb_stack"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x5753ce9124a29a06(["ridge_ca_pdf"]):::uptodate
    x0e4394c89ab817da(["ca"]):::uptodate --> x5753ce9124a29a06(["ridge_ca_pdf"]):::uptodate
    x9f7f8cade5fecf35(["esa_agb"]):::uptodate --> x6bb719b45bfee760(["xu_agb"]):::uptodate
    x39b0a131ab7dd2d0(["xu_file"]):::uptodate --> x6bb719b45bfee760(["xu_agb"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x23da7f1df93639a1(["sd_map_ca_CA_png"]):::uptodate
    x0e4394c89ab817da(["ca"]):::uptodate --> x23da7f1df93639a1(["sd_map_ca_CA_png"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x0ab64fc891f24c82(["agb_map_ca_CA_png"]):::uptodate
    x0e4394c89ab817da(["ca"]):::uptodate --> x0ab64fc891f24c82(["agb_map_ca_CA_png"]):::uptodate
    x6e52cb0f1668cc22(["readme"]):::dispatched --> x6e52cb0f1668cc22(["readme"]):::dispatched
  end
  classDef uptodate stroke:#000000,color:#ffffff,fill:#354823;
  classDef dispatched stroke:#000000,color:#000000,fill:#DC863B;
  classDef outdated stroke:#000000,color:#000000,fill:#78B7C5;
  classDef none stroke:#000000,color:#000000,fill:#94a4ac;
  linkStyle 0 stroke-width:0px;
  linkStyle 1 stroke-width:0px;
  linkStyle 2 stroke-width:0px;
  linkStyle 3 stroke-width:0px;
  linkStyle 109 stroke-width:0px;
```

## File structure

``` r
fs::dir_tree(recurse = 1)
```

    .
    ├── LICENSE
    ├── R
    │   ├── calc_summary.R
    │   ├── crop_srer.R
    │   ├── get_esa_crs.R
    │   ├── make_az_sf.R
    │   ├── make_shape_list.R
    │   ├── plot_agb_map.R
    │   ├── plot_agb_ridges.R
    │   ├── plot_median_map.R
    │   ├── plot_scatter.R
    │   ├── plot_sd_map.R
    │   ├── project_crop_esa.R
    │   ├── read_clean_chopping.R
    │   ├── read_clean_esa.R
    │   ├── read_clean_gedi.R
    │   ├── read_clean_liu.R
    │   ├── read_clean_lt_gnn.R
    │   ├── read_clean_menlove.R
    │   ├── read_clean_rap.R
    │   ├── read_clean_xu.R
    │   ├── trim_image.R
    │   └── zip_plots.R
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
    │   └── report.qmd
    └── notes
        ├── improve ridges.R
        ├── kernel_estimation.R
        ├── mosaic_tiles.R
        ├── pointdensity_plots.R
        ├── srer_map.R
        └── violin_plots.R

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
