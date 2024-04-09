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

### `renv`

This project uses
[`renv`](https://rstudio.github.io/renv/articles/renv.html) for package
management. When opening this repo as an RStudio Project for the first
time, `renv` should automatically install itself and prompt you to run
`renv::restore()` to install all package dependencies.

### `targets`

This project uses the [`targets`
package](https://docs.ropensci.org/targets/) for workflow management.
Run `targets::tar_make()` from the console to run the workflow and
reproduce all results. The graph below shows the workflow:

Loading required namespace: terra

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
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x699ca8a0068688fa(["median_map_az_png<br>az png"]):::uptodate
    x7fb455d668686b01(["az"]):::uptodate --> x699ca8a0068688fa(["median_map_az_png<br>az png"]):::uptodate
    x7abafd87efa13647(["agb_df_az"]):::uptodate --> xa5177effe50f87b0(["plot_comparisons"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x71b7dbda01472286(["agb_map_srer_pdf<br>srer pdf"]):::uptodate
    xe3a3f405d949368a(["srer"]):::uptodate --> x71b7dbda01472286(["agb_map_srer_pdf<br>srer pdf"]):::uptodate
    x9f7f8cade5fecf35(["esa_agb"]):::uptodate --> x0a69ba6feca06d1c(["sites_esa_agb<br>esa_agb"]):::uptodate
    xc554de50178f767d(["site_locs"]):::uptodate --> x0a69ba6feca06d1c(["sites_esa_agb<br>esa_agb"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> xe6d513174df05539(["sd_map_ca_pdf<br>ca pdf"]):::uptodate
    x0e4394c89ab817da(["ca"]):::uptodate --> xe6d513174df05539(["sd_map_ca_pdf<br>ca pdf"]):::uptodate
    x7fb455d668686b01(["az"]):::uptodate --> x5cbd07d8ce48e961(["subsets"]):::uptodate
    x0e4394c89ab817da(["ca"]):::uptodate --> x5cbd07d8ce48e961(["subsets"]):::uptodate
    xe5fe7e4eb140dcfa(["pima"]):::uptodate --> x5cbd07d8ce48e961(["subsets"]):::uptodate
    xe3a3f405d949368a(["srer"]):::uptodate --> x5cbd07d8ce48e961(["subsets"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x5f2c2a5de9c73409(["median_map_srer_png<br>srer png"]):::uptodate
    xe3a3f405d949368a(["srer"]):::uptodate --> x5f2c2a5de9c73409(["median_map_srer_png<br>srer png"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x8cd5f216cf01eefb(["agb_map_az_pdf<br>az pdf"]):::uptodate
    x7fb455d668686b01(["az"]):::uptodate --> x8cd5f216cf01eefb(["agb_map_az_pdf<br>az pdf"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> xc8d1f4f8b0320bf6(["agb_map_srer_png<br>srer png"]):::uptodate
    xe3a3f405d949368a(["srer"]):::uptodate --> xc8d1f4f8b0320bf6(["agb_map_srer_png<br>srer png"]):::uptodate
    x64ac68d6665db59b(["conus"]):::uptodate --> x9f7f8cade5fecf35(["esa_agb"]):::uptodate
    x3f42aa24c75ef1fe(["esa_files"]):::uptodate --> x9f7f8cade5fecf35(["esa_agb"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> xb6b26dab56b30531(["sd_map_ca_png<br>ca png"]):::uptodate
    x0e4394c89ab817da(["ca"]):::uptodate --> xb6b26dab56b30531(["sd_map_ca_png<br>ca png"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> xe3a3f405d949368a(["srer"]):::uptodate
    xc7f156126aa49133(["srer_dir"]):::uptodate --> xe3a3f405d949368a(["srer"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x7f5b21a1115ff63a(["sd_map_srer_png<br>srer png"]):::uptodate
    xe3a3f405d949368a(["srer"]):::uptodate --> x7f5b21a1115ff63a(["sd_map_srer_png<br>srer png"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x5b76edab95fa1a87(["ridge_az_pdf<br>pdf"]):::uptodate
    x7fb455d668686b01(["az"]):::uptodate --> x5b76edab95fa1a87(["ridge_az_pdf<br>pdf"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> xe26c29a782da5ac5(["agb_map_az_png<br>az png"]):::uptodate
    x7fb455d668686b01(["az"]):::uptodate --> xe26c29a782da5ac5(["agb_map_az_png<br>az png"]):::uptodate
    x64ac68d6665db59b(["conus"]):::uptodate --> xe4f3f2f15e724def(["liu_agb"]):::uptodate
    x9f7f8cade5fecf35(["esa_agb"]):::uptodate --> xe4f3f2f15e724def(["liu_agb"]):::uptodate
    x26d0dae1bf6fcb39(["liu_file"]):::uptodate --> xe4f3f2f15e724def(["liu_agb"]):::uptodate
    xc554de50178f767d(["site_locs"]):::uptodate --> x158f508064ee85d6(["sites_wide_csv"]):::uptodate
    x59957da05f0a94b9(["sites_chopping_agb<br>chopping_agb"]):::uptodate --> x158f508064ee85d6(["sites_wide_csv"]):::uptodate
    x0a69ba6feca06d1c(["sites_esa_agb<br>esa_agb"]):::uptodate --> x158f508064ee85d6(["sites_wide_csv"]):::uptodate
    x77722cec98ceb357(["sites_gedi_agb<br>gedi_agb"]):::uptodate --> x158f508064ee85d6(["sites_wide_csv"]):::uptodate
    x6623973e57f5b8e6(["sites_liu_agb<br>liu_agb"]):::uptodate --> x158f508064ee85d6(["sites_wide_csv"]):::uptodate
    x8943a84d03c43549(["sites_ltgnn_agb<br>ltgnn_agb"]):::uptodate --> x158f508064ee85d6(["sites_wide_csv"]):::uptodate
    x56472736440e67f4(["sites_menlove_agb<br>menlove_agb"]):::uptodate --> x158f508064ee85d6(["sites_wide_csv"]):::uptodate
    xda98312af81e9c50(["sites_xu_agb<br>xu_agb"]):::uptodate --> x158f508064ee85d6(["sites_wide_csv"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x889e103f0ca22367(["ridge_pima_pdf<br>pdf"]):::uptodate
    xe5fe7e4eb140dcfa(["pima"]):::uptodate --> x889e103f0ca22367(["ridge_pima_pdf<br>pdf"]):::uptodate
    xa9c8870bcb5985fd["scatter_plots"]:::uptodate --> x0ed052f6c2f4c6d2(["zip_scatter_plots"]):::uptodate
    x64ac68d6665db59b(["conus"]):::uptodate --> xb420f92ea294cb0b(["menlove_agb"]):::uptodate
    x9f7f8cade5fecf35(["esa_agb"]):::uptodate --> xb420f92ea294cb0b(["menlove_agb"]):::uptodate
    x5086af9665941a9e(["menlove_dir"]):::uptodate --> xb420f92ea294cb0b(["menlove_agb"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> xea472a606bc6a80f(["sd_map_pima_pdf<br>pima pdf"]):::uptodate
    xe5fe7e4eb140dcfa(["pima"]):::uptodate --> xea472a606bc6a80f(["sd_map_pima_pdf<br>pima pdf"]):::uptodate
    xe4f3f2f15e724def(["liu_agb"]):::uptodate --> x6623973e57f5b8e6(["sites_liu_agb<br>liu_agb"]):::uptodate
    xc554de50178f767d(["site_locs"]):::uptodate --> x6623973e57f5b8e6(["sites_liu_agb<br>liu_agb"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x3e460264400a47f9(["median_map_ca_pdf<br>ca pdf"]):::uptodate
    x0e4394c89ab817da(["ca"]):::uptodate --> x3e460264400a47f9(["median_map_ca_pdf<br>ca pdf"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x5753ce9124a29a06(["ridge_ca_pdf<br>pdf"]):::uptodate
    x0e4394c89ab817da(["ca"]):::uptodate --> x5753ce9124a29a06(["ridge_ca_pdf<br>pdf"]):::uptodate
    x64ac68d6665db59b(["conus"]):::uptodate --> x5bee436f312cca80(["gedi_agb"]):::uptodate
    x9f7f8cade5fecf35(["esa_agb"]):::uptodate --> x5bee436f312cca80(["gedi_agb"]):::uptodate
    x8d7fb25f1e16bc4f(["gedi_file"]):::uptodate --> x5bee436f312cca80(["gedi_agb"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x94946b2cdd11e112(["agb_map_ca_pdf<br>ca pdf"]):::uptodate
    x0e4394c89ab817da(["ca"]):::uptodate --> x94946b2cdd11e112(["agb_map_ca_pdf<br>ca pdf"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> xa001815ff57339d2(["median_map_az_pdf<br>az pdf"]):::uptodate
    x7fb455d668686b01(["az"]):::uptodate --> xa001815ff57339d2(["median_map_az_pdf<br>az pdf"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x31a8f9ae377f5b5a(["ridge_srer_pdf<br>pdf"]):::uptodate
    xe3a3f405d949368a(["srer"]):::uptodate --> x31a8f9ae377f5b5a(["ridge_srer_pdf<br>pdf"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x853e79625694a360(["ridge_pima_png<br>png"]):::uptodate
    xe5fe7e4eb140dcfa(["pima"]):::uptodate --> x853e79625694a360(["ridge_pima_png<br>png"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x7abafd87efa13647(["agb_df_az"]):::uptodate
    x7fb455d668686b01(["az"]):::uptodate --> x7abafd87efa13647(["agb_df_az"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x0a6b9a67bcd0c70a(["agb_map_ca_png<br>ca png"]):::uptodate
    x0e4394c89ab817da(["ca"]):::uptodate --> x0a6b9a67bcd0c70a(["agb_map_ca_png<br>ca png"]):::uptodate
    xe26c29a782da5ac5(["agb_map_az_png<br>az png"]):::uptodate --> xe0fba61fbc506510(["report"]):::outdated
    x0a6b9a67bcd0c70a(["agb_map_ca_png<br>ca png"]):::uptodate --> xe0fba61fbc506510(["report"]):::outdated
    xb7aedba3b60a69b7(["agb_map_pima_png<br>pima png"]):::uptodate --> xe0fba61fbc506510(["report"]):::outdated
    xc8d1f4f8b0320bf6(["agb_map_srer_png<br>srer png"]):::uptodate --> xe0fba61fbc506510(["report"]):::outdated
    x699ca8a0068688fa(["median_map_az_png<br>az png"]):::uptodate --> xe0fba61fbc506510(["report"]):::outdated
    x5c325302d7cd68a7(["median_map_ca_png<br>ca png"]):::uptodate --> xe0fba61fbc506510(["report"]):::outdated
    x754426ac252a6210(["median_map_pima_png<br>pima png"]):::uptodate --> xe0fba61fbc506510(["report"]):::outdated
    x5f2c2a5de9c73409(["median_map_srer_png<br>srer png"]):::uptodate --> xe0fba61fbc506510(["report"]):::outdated
    xb8f1367168074e6c(["ridge_az_png<br>png"]):::uptodate --> xe0fba61fbc506510(["report"]):::outdated
    x60c69b5a4aa33a2c(["ridge_ca_png<br>png"]):::uptodate --> xe0fba61fbc506510(["report"]):::outdated
    x853e79625694a360(["ridge_pima_png<br>png"]):::uptodate --> xe0fba61fbc506510(["report"]):::outdated
    x377c593b0eb4d7e4(["ridge_srer_png<br>png"]):::uptodate --> xe0fba61fbc506510(["report"]):::outdated
    xa9c8870bcb5985fd["scatter_plots"]:::uptodate --> xe0fba61fbc506510(["report"]):::outdated
    xf671b7369bfa8ec1(["sd_map_az_png<br>az png"]):::uptodate --> xe0fba61fbc506510(["report"]):::outdated
    xb6b26dab56b30531(["sd_map_ca_png<br>ca png"]):::uptodate --> xe0fba61fbc506510(["report"]):::outdated
    x4ddb5a4dffb2b7e4(["sd_map_pima_png<br>pima png"]):::uptodate --> xe0fba61fbc506510(["report"]):::outdated
    x7f5b21a1115ff63a(["sd_map_srer_png<br>srer png"]):::uptodate --> xe0fba61fbc506510(["report"]):::outdated
    x0faa310f699b45a5["summary_stats"]:::outdated --> xe0fba61fbc506510(["report"]):::outdated
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x377c593b0eb4d7e4(["ridge_srer_png<br>png"]):::uptodate
    xe3a3f405d949368a(["srer"]):::uptodate --> x377c593b0eb4d7e4(["ridge_srer_png<br>png"]):::uptodate
    x7abafd87efa13647(["agb_df_az"]):::uptodate --> xa9c8870bcb5985fd["scatter_plots"]:::uptodate
    xa5177effe50f87b0(["plot_comparisons"]):::uptodate --> xa9c8870bcb5985fd["scatter_plots"]:::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> xecafc3491da13dc8(["agb_map_pima_pdf<br>pima pdf"]):::uptodate
    xe5fe7e4eb140dcfa(["pima"]):::uptodate --> xecafc3491da13dc8(["agb_map_pima_pdf<br>pima pdf"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x7fb455d668686b01(["az"]):::uptodate
    x80cf9d1bb79c21e3(["chopping_file"]):::uptodate --> x10672e980111f5c2(["chopping_agb"]):::uptodate
    x64ac68d6665db59b(["conus"]):::uptodate --> x10672e980111f5c2(["chopping_agb"]):::uptodate
    x9f7f8cade5fecf35(["esa_agb"]):::uptodate --> x10672e980111f5c2(["chopping_agb"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x8eb9930459a46535(["sd_map_az_pdf<br>az pdf"]):::uptodate
    x7fb455d668686b01(["az"]):::uptodate --> x8eb9930459a46535(["sd_map_az_pdf<br>az pdf"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> xefaff5eee7cf7a6e(["sd_map_srer_pdf<br>srer pdf"]):::uptodate
    xe3a3f405d949368a(["srer"]):::uptodate --> xefaff5eee7cf7a6e(["sd_map_srer_pdf<br>srer pdf"]):::uptodate
    x46fb5bba1213652f(["neon_field_path"]):::uptodate --> xc554de50178f767d(["site_locs"]):::uptodate
    x84df64b9e7573821(["neon_kmz"]):::uptodate --> xc554de50178f767d(["site_locs"]):::uptodate
    x10672e980111f5c2(["chopping_agb"]):::uptodate --> x59957da05f0a94b9(["sites_chopping_agb<br>chopping_agb"]):::uptodate
    xc554de50178f767d(["site_locs"]):::uptodate --> x59957da05f0a94b9(["sites_chopping_agb<br>chopping_agb"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> xb8f1367168074e6c(["ridge_az_png<br>png"]):::uptodate
    x7fb455d668686b01(["az"]):::uptodate --> xb8f1367168074e6c(["ridge_az_png<br>png"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x0e4394c89ab817da(["ca"]):::uptodate
    xb420f92ea294cb0b(["menlove_agb"]):::uptodate --> x56472736440e67f4(["sites_menlove_agb<br>menlove_agb"]):::uptodate
    xc554de50178f767d(["site_locs"]):::uptodate --> x56472736440e67f4(["sites_menlove_agb<br>menlove_agb"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> xf671b7369bfa8ec1(["sd_map_az_png<br>az png"]):::uptodate
    x7fb455d668686b01(["az"]):::uptodate --> xf671b7369bfa8ec1(["sd_map_az_png<br>az png"]):::uptodate
    x64ac68d6665db59b(["conus"]):::uptodate --> x7ff1622cd5d030f8(["ltgnn_agb"]):::uptodate
    x9f7f8cade5fecf35(["esa_agb"]):::uptodate --> x7ff1622cd5d030f8(["ltgnn_agb"]):::uptodate
    xa3cc1c4ee35f32f3(["ltgnn_files"]):::uptodate --> x7ff1622cd5d030f8(["ltgnn_agb"]):::uptodate
    xc554de50178f767d(["site_locs"]):::uptodate --> xda98312af81e9c50(["sites_xu_agb<br>xu_agb"]):::uptodate
    x6bb719b45bfee760(["xu_agb"]):::uptodate --> xda98312af81e9c50(["sites_xu_agb<br>xu_agb"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x7243b1db001776ca(["median_map_srer_pdf<br>srer pdf"]):::uptodate
    xe3a3f405d949368a(["srer"]):::uptodate --> x7243b1db001776ca(["median_map_srer_pdf<br>srer pdf"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x5c325302d7cd68a7(["median_map_ca_png<br>ca png"]):::uptodate
    x0e4394c89ab817da(["ca"]):::uptodate --> x5c325302d7cd68a7(["median_map_ca_png<br>ca png"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> xe5fe7e4eb140dcfa(["pima"]):::uptodate
    x87c08b8965ac44dd(["pima_dir"]):::uptodate --> xe5fe7e4eb140dcfa(["pima"]):::uptodate
    x5bee436f312cca80(["gedi_agb"]):::uptodate --> x77722cec98ceb357(["sites_gedi_agb<br>gedi_agb"]):::uptodate
    xc554de50178f767d(["site_locs"]):::uptodate --> x77722cec98ceb357(["sites_gedi_agb<br>gedi_agb"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x60c69b5a4aa33a2c(["ridge_ca_png<br>png"]):::uptodate
    x0e4394c89ab817da(["ca"]):::uptodate --> x60c69b5a4aa33a2c(["ridge_ca_png<br>png"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x536a150d35fef242(["median_map_pima_pdf<br>pima pdf"]):::uptodate
    xe5fe7e4eb140dcfa(["pima"]):::uptodate --> x536a150d35fef242(["median_map_pima_pdf<br>pima pdf"]):::uptodate
    x7ff1622cd5d030f8(["ltgnn_agb"]):::uptodate --> x8943a84d03c43549(["sites_ltgnn_agb<br>ltgnn_agb"]):::uptodate
    xc554de50178f767d(["site_locs"]):::uptodate --> x8943a84d03c43549(["sites_ltgnn_agb<br>ltgnn_agb"]):::uptodate
    xa7439ac6bc73eed5(["ca_az"]):::uptodate --> x74a8a38fc5a3e271(["agb_stack"]):::uptodate
    x10672e980111f5c2(["chopping_agb"]):::uptodate --> x74a8a38fc5a3e271(["agb_stack"]):::uptodate
    x9f7f8cade5fecf35(["esa_agb"]):::uptodate --> x74a8a38fc5a3e271(["agb_stack"]):::uptodate
    x5bee436f312cca80(["gedi_agb"]):::uptodate --> x74a8a38fc5a3e271(["agb_stack"]):::uptodate
    xe4f3f2f15e724def(["liu_agb"]):::uptodate --> x74a8a38fc5a3e271(["agb_stack"]):::uptodate
    x7ff1622cd5d030f8(["ltgnn_agb"]):::uptodate --> x74a8a38fc5a3e271(["agb_stack"]):::uptodate
    xb420f92ea294cb0b(["menlove_agb"]):::uptodate --> x74a8a38fc5a3e271(["agb_stack"]):::uptodate
    x6bb719b45bfee760(["xu_agb"]):::uptodate --> x74a8a38fc5a3e271(["agb_stack"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x0faa310f699b45a5["summary_stats"]:::outdated
    x5cbd07d8ce48e961(["subsets"]):::uptodate --> x0faa310f699b45a5["summary_stats"]:::outdated
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> xb7aedba3b60a69b7(["agb_map_pima_png<br>pima png"]):::uptodate
    xe5fe7e4eb140dcfa(["pima"]):::uptodate --> xb7aedba3b60a69b7(["agb_map_pima_png<br>pima png"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x754426ac252a6210(["median_map_pima_png<br>pima png"]):::uptodate
    xe5fe7e4eb140dcfa(["pima"]):::uptodate --> x754426ac252a6210(["median_map_pima_png<br>pima png"]):::uptodate
    x64ac68d6665db59b(["conus"]):::uptodate --> x6bb719b45bfee760(["xu_agb"]):::uptodate
    x9f7f8cade5fecf35(["esa_agb"]):::uptodate --> x6bb719b45bfee760(["xu_agb"]):::uptodate
    x39b0a131ab7dd2d0(["xu_file"]):::uptodate --> x6bb719b45bfee760(["xu_agb"]):::uptodate
    x74a8a38fc5a3e271(["agb_stack"]):::uptodate --> x4ddb5a4dffb2b7e4(["sd_map_pima_png<br>pima png"]):::uptodate
    xe5fe7e4eb140dcfa(["pima"]):::uptodate --> x4ddb5a4dffb2b7e4(["sd_map_pima_png<br>pima png"]):::uptodate
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
  linkStyle 156 stroke-width:0px;
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
    │   ├── extract_agb_site.R
    │   ├── get_esa_crs.R
    │   ├── get_site_locs.R
    │   ├── make_agb_stack.R
    │   ├── make_az_sf.R
    │   ├── make_ca_az_sf.R
    │   ├── make_shape_list.R
    │   ├── pivot_sites.R
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
    ├── _targets_packages.R
    ├── data
    │   ├── rasters
    │   └── shapefiles
    ├── docs
    │   ├── fig
    │   ├── report.html
    │   ├── report.qmd
    │   ├── report_files
    │   └── site_data.csv
    ├── notes
    │   ├── NEON_data.png
    │   ├── ameriflux.R
    │   ├── estimate_file_sizes.R
    │   ├── improve ridges.R
    │   ├── kernel_estimation.R
    │   ├── mosaic_tiles.R
    │   ├── neon_usfs_data.R
    │   ├── pointdensity_plots.R
    │   ├── scaled_sd.R
    │   ├── srer_map.R
    │   └── violin_plots.R
    ├── renv
    │   ├── activate.R
    │   ├── library
    │   ├── settings.json
    │   └── staging
    ├── renv.lock
    └── sync_data.R

- `R/` contains functions used in the `targets` pipeline.
- `_targets` is generated by `targets::tar_make()` and only the metadata
  of the targets pipeline is on GitHub.
- `_targets.R` defines a `targets` workflow
- `data/rasters` is where data files for each of the data products
  should be placed in order to reproduce this workflow. More detailed
  instructions on what files are there TBD.
- `data/shapefiles` contains shapefiles.
- `docs/` contains output figures and reports that are rendered.
- `notes/` contains scripts with “sketches” about how to do things
- `renv` and `renv.lock` are necessary for the `renv` package to work
  (see above)
- `_targets_packages.R` is generated by `targets::tar_renv()` and allow
  `renv` to capture pipeline dependencies
- `sync_data.R` has some example code for figuring out which raw data
  files are actually currently used by the pipeline and syncing them to
  remote servers
