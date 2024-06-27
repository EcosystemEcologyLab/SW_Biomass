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

terra 1.7.78

Attaching package: ‘tidyr’

The following object is masked from ‘package:terra’:

    extract

tar_source() only sources R scripts. Ignoring non-R files: R/.DS_Store

``` mermaid
graph LR
  style Legend fill:#FFFFFF00,stroke:#000000;
  style Graph fill:#FFFFFF00,stroke:#000000;
  subgraph Legend
    direction LR
    x2db1ec7a48f65a9b([""Outdated""]):::outdated --- xf1522833a4d242c5([""Up to date""]):::uptodate
    xf1522833a4d242c5([""Up to date""]):::uptodate --- xb6630624a7b3aa0f([""Dispatched""]):::dispatched
    xb6630624a7b3aa0f([""Dispatched""]):::dispatched --- xd03d7c7dd2ddda2b([""Stem""]):::none
    xd03d7c7dd2ddda2b([""Stem""]):::none --- x6f7e04ea3427f824[""Pattern""]:::none
  end
  subgraph Graph
    direction LR
    xd175b91b13bd123d(["az"]):::uptodate --> x297cb1c9bfe8c8da(["summary_xu_agb_az<br>xu_agb az"]):::uptodate
    x55cd1a25824d6c45(["xu_agb"]):::uptodate --> x297cb1c9bfe8c8da(["summary_xu_agb_az<br>xu_agb az"]):::uptodate
    x20b6251b56892c2a(["esa_agb"]):::uptodate --> xad1aea4a1567358b(["summary_esa_agb_pima<br>esa_agb pima"]):::uptodate
    xc7806e6395dc77f0(["pima"]):::uptodate --> xad1aea4a1567358b(["summary_esa_agb_pima<br>esa_agb pima"]):::uptodate
    xb65229902e01e989(["ca"]):::uptodate --> x1f8593eda88299b6(["summary_menlove_agb_ca<br>menlove_agb ca"]):::uptodate
    x434f37652a8b2dac(["menlove_agb"]):::uptodate --> x1f8593eda88299b6(["summary_menlove_agb_ca<br>menlove_agb ca"]):::uptodate
    x2d046568113c38ec["scatter_plots"]:::outdated --> x1cedc3c7f523e7cc(["zip_scatter_plots"]):::outdated
    xb65229902e01e989(["ca"]):::uptodate --> xa88356e3cef441a2(["summary_xu_agb_ca<br>xu_agb ca"]):::uptodate
    x55cd1a25824d6c45(["xu_agb"]):::uptodate --> xa88356e3cef441a2(["summary_xu_agb_ca<br>xu_agb ca"]):::uptodate
    x434f37652a8b2dac(["menlove_agb"]):::uptodate --> x925dfc9a156452e7(["summary_menlove_agb_pima<br>menlove_agb pima"]):::uptodate
    xc7806e6395dc77f0(["pima"]):::uptodate --> x925dfc9a156452e7(["summary_menlove_agb_pima<br>menlove_agb pima"]):::uptodate
    x0c544fc75086be79(["agb_stack"]):::uptodate --> x9db81f788ddc3e77(["ridge_az_png<br>png"]):::uptodate
    xd175b91b13bd123d(["az"]):::uptodate --> x9db81f788ddc3e77(["ridge_az_png<br>png"]):::uptodate
    xb65229902e01e989(["ca"]):::uptodate --> x8ce84c56745a6bf9(["sd_summary_ca<br>ca"]):::uptodate
    x6996dfdacea90a2e(["sd_stack"]):::uptodate --> x8ce84c56745a6bf9(["sd_summary_ca<br>ca"]):::uptodate
    x20b6251b56892c2a(["esa_agb"]):::uptodate --> xbc2e015a055d8c13(["common_liu_agb<br>liu_agb"]):::uptodate
    x9126df164c036a5c(["liu_agb"]):::uptodate --> xbc2e015a055d8c13(["common_liu_agb<br>liu_agb"]):::uptodate
    x982c4ea78b58d1bb(["ca_az"]):::uptodate --> x434f37652a8b2dac(["menlove_agb"]):::uptodate
    xdcf1d8078ca1b138(["menlove_file"]):::uptodate --> x434f37652a8b2dac(["menlove_agb"]):::uptodate
    xb65229902e01e989(["ca"]):::uptodate --> x99b6ef97d01b006a(["sd_map_ca_pdf<br>ca pdf"]):::uptodate
    x6996dfdacea90a2e(["sd_stack"]):::uptodate --> x99b6ef97d01b006a(["sd_map_ca_pdf<br>ca pdf"]):::uptodate
    x20b6251b56892c2a(["esa_agb"]):::uptodate --> xfaa2939ab738050a(["common_ltgnn_agb<br>ltgnn_agb"]):::uptodate
    xf99622c5fc8ef45a(["ltgnn_agb"]):::uptodate --> xfaa2939ab738050a(["common_ltgnn_agb<br>ltgnn_agb"]):::uptodate
    x8df052bdc143da31(["srer_file"]):::uptodate --> x0838d78c836918b1(["srer"]):::uptodate
    xb65229902e01e989(["ca"]):::uptodate --> x6f9571f76fb08c01(["sd_map_ca_png<br>ca png"]):::uptodate
    x6996dfdacea90a2e(["sd_stack"]):::uptodate --> x6f9571f76fb08c01(["sd_map_ca_png<br>ca png"]):::uptodate
    xc7806e6395dc77f0(["pima"]):::uptodate --> x98aa47b23555b2af(["sd_map_pima_pdf<br>pima pdf"]):::uptodate
    x6996dfdacea90a2e(["sd_stack"]):::uptodate --> x98aa47b23555b2af(["sd_map_pima_pdf<br>pima pdf"]):::uptodate
    x20b6251b56892c2a(["esa_agb"]):::uptodate --> xb5e098dd226b06af(["common_xu_agb<br>xu_agb"]):::uptodate
    x55cd1a25824d6c45(["xu_agb"]):::uptodate --> xb5e098dd226b06af(["common_xu_agb<br>xu_agb"]):::uptodate
    x6996dfdacea90a2e(["sd_stack"]):::uptodate --> xa136827e6574e960(["sd_map_srer_png<br>srer png"]):::uptodate
    x0838d78c836918b1(["srer"]):::uptodate --> xa136827e6574e960(["sd_map_srer_png<br>srer png"]):::uptodate
    x0c544fc75086be79(["agb_stack"]):::uptodate --> x8fb024c3aab62b0a(["ridge_srer_png<br>png"]):::uptodate
    x0838d78c836918b1(["srer"]):::uptodate --> x8fb024c3aab62b0a(["ridge_srer_png<br>png"]):::uptodate
    xb65229902e01e989(["ca"]):::uptodate --> xded0aaf436b8c9d9(["summary_chopping_agb_ca<br>chopping_agb ca"]):::uptodate
    xf4e158caecdccb15(["chopping_agb"]):::uptodate --> xded0aaf436b8c9d9(["summary_chopping_agb_ca<br>chopping_agb ca"]):::uptodate
    x0c544fc75086be79(["agb_stack"]):::uptodate --> x693953566a2ca630(["agb_df_az"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> x693953566a2ca630(["agb_df_az"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> x451ca032464ffb2d(["sd_summary_az<br>az"]):::uptodate
    x6996dfdacea90a2e(["sd_stack"]):::uptodate --> x451ca032464ffb2d(["sd_summary_az<br>az"]):::uptodate
    x0c544fc75086be79(["agb_stack"]):::uptodate --> x9026d3689638e855(["ridge_pima_png<br>png"]):::uptodate
    xc7806e6395dc77f0(["pima"]):::uptodate --> x9026d3689638e855(["ridge_pima_png<br>png"]):::uptodate
    xb65229902e01e989(["ca"]):::uptodate --> x7e1c93717472f9aa(["summary_esa_agb_ca<br>esa_agb ca"]):::uptodate
    x20b6251b56892c2a(["esa_agb"]):::uptodate --> x7e1c93717472f9aa(["summary_esa_agb_ca<br>esa_agb ca"]):::uptodate
    x20b6251b56892c2a(["esa_agb"]):::uptodate --> x992f964344973711(["summary_esa_agb_srer<br>esa_agb srer"]):::uptodate
    x0838d78c836918b1(["srer"]):::uptodate --> x992f964344973711(["summary_esa_agb_srer<br>esa_agb srer"]):::uptodate
    x0c544fc75086be79(["agb_stack"]):::uptodate --> xa873944eb0f3630d(["median_map_az_pdf<br>az pdf"]):::uptodate
    xd175b91b13bd123d(["az"]):::uptodate --> xa873944eb0f3630d(["median_map_az_pdf<br>az pdf"]):::uptodate
    xc7806e6395dc77f0(["pima"]):::uptodate --> x506d09120f6511a5(["sd_summary_pima<br>pima"]):::uptodate
    x6996dfdacea90a2e(["sd_stack"]):::uptodate --> x506d09120f6511a5(["sd_summary_pima<br>pima"]):::uptodate
    x0c544fc75086be79(["agb_stack"]):::uptodate --> x870b061d4d3330a9(["median_map_ca_pdf<br>ca pdf"]):::uptodate
    xb65229902e01e989(["ca"]):::uptodate --> x870b061d4d3330a9(["median_map_ca_pdf<br>ca pdf"]):::uptodate
    xad3c233602b55f5e(["gedi_agb"]):::uptodate --> xe1476ac1d38c63f1(["summary_gedi_agb_srer<br>gedi_agb srer"]):::uptodate
    x0838d78c836918b1(["srer"]):::uptodate --> xe1476ac1d38c63f1(["summary_gedi_agb_srer<br>gedi_agb srer"]):::uptodate
    x0c544fc75086be79(["agb_stack"]):::uptodate --> xb9c1d12e637f675e(["median_map_srer_pdf<br>srer pdf"]):::uptodate
    x0838d78c836918b1(["srer"]):::uptodate --> xb9c1d12e637f675e(["median_map_srer_pdf<br>srer pdf"]):::uptodate
    xb65229902e01e989(["ca"]):::uptodate --> x8af87cf95f690fdd(["summary_ltgnn_agb_ca<br>ltgnn_agb ca"]):::uptodate
    xf99622c5fc8ef45a(["ltgnn_agb"]):::uptodate --> x8af87cf95f690fdd(["summary_ltgnn_agb_ca<br>ltgnn_agb ca"]):::uptodate
    x9126df164c036a5c(["liu_agb"]):::uptodate --> x58d935dcc353b7c5(["summary_liu_agb_pima<br>liu_agb pima"]):::uptodate
    xc7806e6395dc77f0(["pima"]):::uptodate --> x58d935dcc353b7c5(["summary_liu_agb_pima<br>liu_agb pima"]):::uptodate
    xcb744cc5b3c011de(["median_map_az_png<br>az png"]):::uptodate --> xb72891f20a5b8df1(["report"]):::outdated
    xbccfd088a963c01b(["median_map_ca_png<br>ca png"]):::uptodate --> xb72891f20a5b8df1(["report"]):::outdated
    x05a99b56c623bdbf(["median_map_pima_png<br>pima png"]):::uptodate --> xb72891f20a5b8df1(["report"]):::outdated
    x599ce45254dfcf12(["median_map_srer_png<br>srer png"]):::uptodate --> xb72891f20a5b8df1(["report"]):::outdated
    x9db81f788ddc3e77(["ridge_az_png<br>png"]):::uptodate --> xb72891f20a5b8df1(["report"]):::outdated
    x494a8da183e6456e(["ridge_ca_png<br>png"]):::outdated --> xb72891f20a5b8df1(["report"]):::outdated
    x9026d3689638e855(["ridge_pima_png<br>png"]):::uptodate --> xb72891f20a5b8df1(["report"]):::outdated
    x8fb024c3aab62b0a(["ridge_srer_png<br>png"]):::uptodate --> xb72891f20a5b8df1(["report"]):::outdated
    x2d046568113c38ec["scatter_plots"]:::outdated --> xb72891f20a5b8df1(["report"]):::outdated
    x5d46a426d10236f5(["sd_map_az_png<br>az png"]):::uptodate --> xb72891f20a5b8df1(["report"]):::outdated
    x6f9571f76fb08c01(["sd_map_ca_png<br>ca png"]):::uptodate --> xb72891f20a5b8df1(["report"]):::outdated
    x65d586cb69f78e35(["sd_map_pima_png<br>pima png"]):::uptodate --> xb72891f20a5b8df1(["report"]):::outdated
    xa136827e6574e960(["sd_map_srer_png<br>srer png"]):::uptodate --> xb72891f20a5b8df1(["report"]):::outdated
    x693953566a2ca630(["agb_df_az"]):::outdated --> xfe340e9d3143cfe1(["plot_comparisons"]):::outdated
    xb65229902e01e989(["ca"]):::uptodate --> x896413cc498fed05(["summary_gedi_agb_ca<br>gedi_agb ca"]):::uptodate
    xad3c233602b55f5e(["gedi_agb"]):::uptodate --> x896413cc498fed05(["summary_gedi_agb_ca<br>gedi_agb ca"]):::uptodate
    xd175b91b13bd123d(["az"]):::uptodate --> xca36019d8d1a7560(["summary_chopping_agb_az<br>chopping_agb az"]):::uptodate
    xf4e158caecdccb15(["chopping_agb"]):::uptodate --> xca36019d8d1a7560(["summary_chopping_agb_az<br>chopping_agb az"]):::uptodate
    xf4e158caecdccb15(["chopping_agb"]):::uptodate --> xf199c7583ab6c0a9(["common_chopping_agb<br>chopping_agb"]):::uptodate
    x20b6251b56892c2a(["esa_agb"]):::uptodate --> xf199c7583ab6c0a9(["common_chopping_agb<br>chopping_agb"]):::uptodate
    x982c4ea78b58d1bb(["ca_az"]):::uptodate --> xf99622c5fc8ef45a(["ltgnn_agb"]):::uptodate
    x1c6bbec0f051deda(["ltgnn_dir"]):::uptodate --> xf99622c5fc8ef45a(["ltgnn_agb"]):::uptodate
    x2234824f61f9f7d3(["agb_stats"]):::uptodate --> x3153cd7d29e09252(["agb_trend_plot"]):::uptodate
    x982c4ea78b58d1bb(["ca_az"]):::uptodate --> xf4e158caecdccb15(["chopping_agb"]):::uptodate
    x34fa7583752e3167(["chopping_file"]):::uptodate --> xf4e158caecdccb15(["chopping_agb"]):::uptodate
    xd175b91b13bd123d(["az"]):::uptodate --> x112aef04749a4df5(["summary_esa_agb_az<br>esa_agb az"]):::uptodate
    x20b6251b56892c2a(["esa_agb"]):::uptodate --> x112aef04749a4df5(["summary_esa_agb_az<br>esa_agb az"]):::uptodate
    xf199c7583ab6c0a9(["common_chopping_agb<br>chopping_agb"]):::uptodate --> x0c544fc75086be79(["agb_stack"]):::uptodate
    x8fcb734dec94a3dc(["common_esa_agb<br>esa_agb"]):::uptodate --> x0c544fc75086be79(["agb_stack"]):::uptodate
    x878143b5a192cb84(["common_gedi_agb<br>gedi_agb"]):::uptodate --> x0c544fc75086be79(["agb_stack"]):::uptodate
    xbc2e015a055d8c13(["common_liu_agb<br>liu_agb"]):::uptodate --> x0c544fc75086be79(["agb_stack"]):::uptodate
    xfaa2939ab738050a(["common_ltgnn_agb<br>ltgnn_agb"]):::uptodate --> x0c544fc75086be79(["agb_stack"]):::uptodate
    x6549143dc2823ae8(["common_menlove_agb<br>menlove_agb"]):::uptodate --> x0c544fc75086be79(["agb_stack"]):::uptodate
    xb5e098dd226b06af(["common_xu_agb<br>xu_agb"]):::uptodate --> x0c544fc75086be79(["agb_stack"]):::uptodate
    x20b6251b56892c2a(["esa_agb"]):::uptodate --> x878143b5a192cb84(["common_gedi_agb<br>gedi_agb"]):::uptodate
    xad3c233602b55f5e(["gedi_agb"]):::uptodate --> x878143b5a192cb84(["common_gedi_agb<br>gedi_agb"]):::uptodate
    x8860eb82d175c50e(["pima_file"]):::uptodate --> xc7806e6395dc77f0(["pima"]):::uptodate
    x0c544fc75086be79(["agb_stack"]):::uptodate --> x599ce45254dfcf12(["median_map_srer_png<br>srer png"]):::uptodate
    x0838d78c836918b1(["srer"]):::uptodate --> x599ce45254dfcf12(["median_map_srer_png<br>srer png"]):::uptodate
    x9126df164c036a5c(["liu_agb"]):::uptodate --> x836c1474b2b954ce(["summary_liu_agb_srer<br>liu_agb srer"]):::uptodate
    x0838d78c836918b1(["srer"]):::uptodate --> x836c1474b2b954ce(["summary_liu_agb_srer<br>liu_agb srer"]):::uptodate
    x0c544fc75086be79(["agb_stack"]):::uptodate --> x494a8da183e6456e(["ridge_ca_png<br>png"]):::outdated
    xb65229902e01e989(["ca"]):::uptodate --> x494a8da183e6456e(["ridge_ca_png<br>png"]):::outdated
    x982c4ea78b58d1bb(["ca_az"]):::uptodate --> x55cd1a25824d6c45(["xu_agb"]):::uptodate
    x4f83a8bb6986eb55(["xu_file"]):::uptodate --> x55cd1a25824d6c45(["xu_agb"]):::uptodate
    xd175b91b13bd123d(["az"]):::uptodate --> x71c929c4a8ec0f41(["summary_ltgnn_agb_az<br>ltgnn_agb az"]):::uptodate
    xf99622c5fc8ef45a(["ltgnn_agb"]):::uptodate --> x71c929c4a8ec0f41(["summary_ltgnn_agb_az<br>ltgnn_agb az"]):::uptodate
    xad3c233602b55f5e(["gedi_agb"]):::uptodate --> x141ee74993477fa3(["summary_gedi_agb_pima<br>gedi_agb pima"]):::uptodate
    xc7806e6395dc77f0(["pima"]):::uptodate --> x141ee74993477fa3(["summary_gedi_agb_pima<br>gedi_agb pima"]):::uptodate
    xca36019d8d1a7560(["summary_chopping_agb_az<br>chopping_agb az"]):::uptodate --> x2234824f61f9f7d3(["agb_stats"]):::uptodate
    xded0aaf436b8c9d9(["summary_chopping_agb_ca<br>chopping_agb ca"]):::uptodate --> x2234824f61f9f7d3(["agb_stats"]):::uptodate
    x43c3d50a4e8b00d1(["summary_chopping_agb_pima<br>chopping_agb pima"]):::uptodate --> x2234824f61f9f7d3(["agb_stats"]):::uptodate
    x812b1e4ddf9794ca(["summary_chopping_agb_srer<br>chopping_agb srer"]):::uptodate --> x2234824f61f9f7d3(["agb_stats"]):::uptodate
    x112aef04749a4df5(["summary_esa_agb_az<br>esa_agb az"]):::uptodate --> x2234824f61f9f7d3(["agb_stats"]):::uptodate
    x7e1c93717472f9aa(["summary_esa_agb_ca<br>esa_agb ca"]):::uptodate --> x2234824f61f9f7d3(["agb_stats"]):::uptodate
    xad1aea4a1567358b(["summary_esa_agb_pima<br>esa_agb pima"]):::uptodate --> x2234824f61f9f7d3(["agb_stats"]):::uptodate
    x992f964344973711(["summary_esa_agb_srer<br>esa_agb srer"]):::uptodate --> x2234824f61f9f7d3(["agb_stats"]):::uptodate
    xb4c172903d361d3d(["summary_gedi_agb_az<br>gedi_agb az"]):::uptodate --> x2234824f61f9f7d3(["agb_stats"]):::uptodate
    x896413cc498fed05(["summary_gedi_agb_ca<br>gedi_agb ca"]):::uptodate --> x2234824f61f9f7d3(["agb_stats"]):::uptodate
    x141ee74993477fa3(["summary_gedi_agb_pima<br>gedi_agb pima"]):::uptodate --> x2234824f61f9f7d3(["agb_stats"]):::uptodate
    xe1476ac1d38c63f1(["summary_gedi_agb_srer<br>gedi_agb srer"]):::uptodate --> x2234824f61f9f7d3(["agb_stats"]):::uptodate
    xbaeb1591fc6a6045(["summary_liu_agb_az<br>liu_agb az"]):::uptodate --> x2234824f61f9f7d3(["agb_stats"]):::uptodate
    x4625742ffe1741f7(["summary_liu_agb_ca<br>liu_agb ca"]):::uptodate --> x2234824f61f9f7d3(["agb_stats"]):::uptodate
    x58d935dcc353b7c5(["summary_liu_agb_pima<br>liu_agb pima"]):::uptodate --> x2234824f61f9f7d3(["agb_stats"]):::uptodate
    x836c1474b2b954ce(["summary_liu_agb_srer<br>liu_agb srer"]):::uptodate --> x2234824f61f9f7d3(["agb_stats"]):::uptodate
    x71c929c4a8ec0f41(["summary_ltgnn_agb_az<br>ltgnn_agb az"]):::uptodate --> x2234824f61f9f7d3(["agb_stats"]):::uptodate
    x8af87cf95f690fdd(["summary_ltgnn_agb_ca<br>ltgnn_agb ca"]):::uptodate --> x2234824f61f9f7d3(["agb_stats"]):::uptodate
    xbf7aee316c25e76f(["summary_ltgnn_agb_pima<br>ltgnn_agb pima"]):::uptodate --> x2234824f61f9f7d3(["agb_stats"]):::uptodate
    xbbde5db4241503a3(["summary_ltgnn_agb_srer<br>ltgnn_agb srer"]):::uptodate --> x2234824f61f9f7d3(["agb_stats"]):::uptodate
    xd2dbc80f3e6e23ba(["summary_menlove_agb_az<br>menlove_agb az"]):::uptodate --> x2234824f61f9f7d3(["agb_stats"]):::uptodate
    x1f8593eda88299b6(["summary_menlove_agb_ca<br>menlove_agb ca"]):::uptodate --> x2234824f61f9f7d3(["agb_stats"]):::uptodate
    x925dfc9a156452e7(["summary_menlove_agb_pima<br>menlove_agb pima"]):::uptodate --> x2234824f61f9f7d3(["agb_stats"]):::uptodate
    x5a21394d375f19b0(["summary_menlove_agb_srer<br>menlove_agb srer"]):::uptodate --> x2234824f61f9f7d3(["agb_stats"]):::uptodate
    x297cb1c9bfe8c8da(["summary_xu_agb_az<br>xu_agb az"]):::uptodate --> x2234824f61f9f7d3(["agb_stats"]):::uptodate
    xa88356e3cef441a2(["summary_xu_agb_ca<br>xu_agb ca"]):::uptodate --> x2234824f61f9f7d3(["agb_stats"]):::uptodate
    x8a5a98d2d83e6967(["summary_xu_agb_pima<br>xu_agb pima"]):::uptodate --> x2234824f61f9f7d3(["agb_stats"]):::uptodate
    x7505c45dd0765765(["summary_xu_agb_srer<br>xu_agb srer"]):::uptodate --> x2234824f61f9f7d3(["agb_stats"]):::uptodate
    xf4e158caecdccb15(["chopping_agb"]):::uptodate --> x812b1e4ddf9794ca(["summary_chopping_agb_srer<br>chopping_agb srer"]):::uptodate
    x0838d78c836918b1(["srer"]):::uptodate --> x812b1e4ddf9794ca(["summary_chopping_agb_srer<br>chopping_agb srer"]):::uptodate
    x434f37652a8b2dac(["menlove_agb"]):::uptodate --> x5a21394d375f19b0(["summary_menlove_agb_srer<br>menlove_agb srer"]):::uptodate
    x0838d78c836918b1(["srer"]):::uptodate --> x5a21394d375f19b0(["summary_menlove_agb_srer<br>menlove_agb srer"]):::uptodate
    xd175b91b13bd123d(["az"]):::uptodate --> xbe39f12168f1b406(["sd_map_az_pdf<br>az pdf"]):::uptodate
    x6996dfdacea90a2e(["sd_stack"]):::uptodate --> xbe39f12168f1b406(["sd_map_az_pdf<br>az pdf"]):::uptodate
    xd175b91b13bd123d(["az"]):::uptodate --> xb4c172903d361d3d(["summary_gedi_agb_az<br>gedi_agb az"]):::uptodate
    xad3c233602b55f5e(["gedi_agb"]):::uptodate --> xb4c172903d361d3d(["summary_gedi_agb_az<br>gedi_agb az"]):::uptodate
    x0c544fc75086be79(["agb_stack"]):::uptodate --> xcb744cc5b3c011de(["median_map_az_png<br>az png"]):::uptodate
    xd175b91b13bd123d(["az"]):::uptodate --> xcb744cc5b3c011de(["median_map_az_png<br>az png"]):::uptodate
    xc7806e6395dc77f0(["pima"]):::uptodate --> x8a5a98d2d83e6967(["summary_xu_agb_pima<br>xu_agb pima"]):::uptodate
    x55cd1a25824d6c45(["xu_agb"]):::uptodate --> x8a5a98d2d83e6967(["summary_xu_agb_pima<br>xu_agb pima"]):::uptodate
    x20b6251b56892c2a(["esa_agb"]):::uptodate --> x6549143dc2823ae8(["common_menlove_agb<br>menlove_agb"]):::uptodate
    x434f37652a8b2dac(["menlove_agb"]):::uptodate --> x6549143dc2823ae8(["common_menlove_agb<br>menlove_agb"]):::uptodate
    xb65229902e01e989(["ca"]):::uptodate --> x4625742ffe1741f7(["summary_liu_agb_ca<br>liu_agb ca"]):::uptodate
    x9126df164c036a5c(["liu_agb"]):::uptodate --> x4625742ffe1741f7(["summary_liu_agb_ca<br>liu_agb ca"]):::uptodate
    x0c544fc75086be79(["agb_stack"]):::uptodate --> xbccfd088a963c01b(["median_map_ca_png<br>ca png"]):::uptodate
    xb65229902e01e989(["ca"]):::uptodate --> xbccfd088a963c01b(["median_map_ca_png<br>ca png"]):::uptodate
    xd175b91b13bd123d(["az"]):::uptodate --> x5d46a426d10236f5(["sd_map_az_png<br>az png"]):::uptodate
    x6996dfdacea90a2e(["sd_stack"]):::uptodate --> x5d46a426d10236f5(["sd_map_az_png<br>az png"]):::uptodate
    x20b6251b56892c2a(["esa_agb"]):::uptodate --> x8fcb734dec94a3dc(["common_esa_agb<br>esa_agb"]):::uptodate
    xf99622c5fc8ef45a(["ltgnn_agb"]):::uptodate --> xbf7aee316c25e76f(["summary_ltgnn_agb_pima<br>ltgnn_agb pima"]):::uptodate
    xc7806e6395dc77f0(["pima"]):::uptodate --> xbf7aee316c25e76f(["summary_ltgnn_agb_pima<br>ltgnn_agb pima"]):::uptodate
    x0c544fc75086be79(["agb_stack"]):::uptodate --> x6996dfdacea90a2e(["sd_stack"]):::uptodate
    x6996dfdacea90a2e(["sd_stack"]):::uptodate --> x69c6379bb16a9ab8(["sd_summary_srer<br>srer"]):::uptodate
    x0838d78c836918b1(["srer"]):::uptodate --> x69c6379bb16a9ab8(["sd_summary_srer<br>srer"]):::uptodate
    x6996dfdacea90a2e(["sd_stack"]):::uptodate --> x80760e6101e4cb1d(["sd_map_srer_pdf<br>srer pdf"]):::uptodate
    x0838d78c836918b1(["srer"]):::uptodate --> x80760e6101e4cb1d(["sd_map_srer_pdf<br>srer pdf"]):::uptodate
    x0838d78c836918b1(["srer"]):::uptodate --> x7505c45dd0765765(["summary_xu_agb_srer<br>xu_agb srer"]):::uptodate
    x55cd1a25824d6c45(["xu_agb"]):::uptodate --> x7505c45dd0765765(["summary_xu_agb_srer<br>xu_agb srer"]):::uptodate
    x693953566a2ca630(["agb_df_az"]):::outdated --> x2d046568113c38ec["scatter_plots"]:::outdated
    xfe340e9d3143cfe1(["plot_comparisons"]):::outdated --> x2d046568113c38ec["scatter_plots"]:::outdated
    xc7806e6395dc77f0(["pima"]):::uptodate --> x65d586cb69f78e35(["sd_map_pima_png<br>pima png"]):::uptodate
    x6996dfdacea90a2e(["sd_stack"]):::uptodate --> x65d586cb69f78e35(["sd_map_pima_png<br>pima png"]):::uptodate
    x0c544fc75086be79(["agb_stack"]):::uptodate --> x1057db013368d12d(["median_map_pima_pdf<br>pima pdf"]):::uptodate
    xc7806e6395dc77f0(["pima"]):::uptodate --> x1057db013368d12d(["median_map_pima_pdf<br>pima pdf"]):::uptodate
    xf99622c5fc8ef45a(["ltgnn_agb"]):::uptodate --> xbbde5db4241503a3(["summary_ltgnn_agb_srer<br>ltgnn_agb srer"]):::uptodate
    x0838d78c836918b1(["srer"]):::uptodate --> xbbde5db4241503a3(["summary_ltgnn_agb_srer<br>ltgnn_agb srer"]):::uptodate
    x982c4ea78b58d1bb(["ca_az"]):::uptodate --> x20b6251b56892c2a(["esa_agb"]):::uptodate
    xb6c60f545bba95c7(["esa_dir"]):::uptodate --> x20b6251b56892c2a(["esa_agb"]):::uptodate
    x0c544fc75086be79(["agb_stack"]):::uptodate --> x05a99b56c623bdbf(["median_map_pima_png<br>pima png"]):::uptodate
    xc7806e6395dc77f0(["pima"]):::uptodate --> x05a99b56c623bdbf(["median_map_pima_png<br>pima png"]):::uptodate
    x451ca032464ffb2d(["sd_summary_az<br>az"]):::uptodate --> xcde81b58306c6eb4(["sd_stats"]):::uptodate
    x8ce84c56745a6bf9(["sd_summary_ca<br>ca"]):::uptodate --> xcde81b58306c6eb4(["sd_stats"]):::uptodate
    x506d09120f6511a5(["sd_summary_pima<br>pima"]):::uptodate --> xcde81b58306c6eb4(["sd_stats"]):::uptodate
    x69c6379bb16a9ab8(["sd_summary_srer<br>srer"]):::uptodate --> xcde81b58306c6eb4(["sd_stats"]):::uptodate
    x982c4ea78b58d1bb(["ca_az"]):::uptodate --> xad3c233602b55f5e(["gedi_agb"]):::uptodate
    x9ba8e1bb2da79809(["gedi_file"]):::uptodate --> xad3c233602b55f5e(["gedi_agb"]):::uptodate
    xd175b91b13bd123d(["az"]):::uptodate --> xd2dbc80f3e6e23ba(["summary_menlove_agb_az<br>menlove_agb az"]):::uptodate
    x434f37652a8b2dac(["menlove_agb"]):::uptodate --> xd2dbc80f3e6e23ba(["summary_menlove_agb_az<br>menlove_agb az"]):::uptodate
    xd175b91b13bd123d(["az"]):::uptodate --> xbaeb1591fc6a6045(["summary_liu_agb_az<br>liu_agb az"]):::uptodate
    x9126df164c036a5c(["liu_agb"]):::uptodate --> xbaeb1591fc6a6045(["summary_liu_agb_az<br>liu_agb az"]):::uptodate
    x982c4ea78b58d1bb(["ca_az"]):::uptodate --> x9126df164c036a5c(["liu_agb"]):::uptodate
    x19766d176d835c12(["liu_file"]):::uptodate --> x9126df164c036a5c(["liu_agb"]):::uptodate
    xf4e158caecdccb15(["chopping_agb"]):::uptodate --> x43c3d50a4e8b00d1(["summary_chopping_agb_pima<br>chopping_agb pima"]):::uptodate
    xc7806e6395dc77f0(["pima"]):::uptodate --> x43c3d50a4e8b00d1(["summary_chopping_agb_pima<br>chopping_agb pima"]):::uptodate
    xc11069275cfeb620(["readme"]):::dispatched --> xc11069275cfeb620(["readme"]):::dispatched
  end
  classDef outdated stroke:#000000,color:#000000,fill:#78B7C5;
  classDef uptodate stroke:#000000,color:#ffffff,fill:#354823;
  classDef dispatched stroke:#000000,color:#000000,fill:#DC863B;
  classDef none stroke:#000000,color:#000000,fill:#94a4ac;
  linkStyle 0 stroke-width:0px;
  linkStyle 1 stroke-width:0px;
  linkStyle 2 stroke-width:0px;
  linkStyle 3 stroke-width:0px;
  linkStyle 197 stroke-width:0px;
```

## File structure

``` r
fs::dir_tree(recurse = 1)
```

    .
    ├── LICENSE
    ├── R
    │   ├── get_az.R
    │   ├── get_ca.R
    │   ├── get_ca_az.R
    │   ├── plot_agb_map.R
    │   ├── plot_agb_ridges.R
    │   ├── plot_agb_trend.R
    │   ├── plot_median_map.R
    │   ├── plot_scatter.R
    │   ├── plot_sd_map.R
    │   ├── project_to_esa.R
    │   ├── read_agb.R
    │   ├── summarize_agb.R
    │   ├── summarize_sd.R
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
    │   ├── AGB_cleaned
    │   └── shapefiles
    ├── docs
    │   ├── fig
    │   ├── report.html
    │   ├── report.qmd
    │   ├── report_files
    │   └── xu_trend.png
    ├── notes
    │   ├── NEON_data.png
    │   ├── ameriflux.R
    │   ├── estimate_file_sizes.R
    │   ├── improve ridges.R
    │   ├── kernel_estimation.R
    │   ├── mosaic_tiles.R
    │   ├── neon_usfs_data.R
    │   ├── plot_doy_trends.R
    │   ├── pointdensity_plots.R
    │   ├── scaled_sd.R
    │   ├── srer_map.R
    │   └── violin_plots.R
    └── sync_data.R

- `R/` contains functions used in the `targets` pipeline.
- `_targets` is generated by `targets::tar_make()` and only the metadata
  of the targets pipeline is on GitHub.
- `_targets.R` defines a `targets` workflow
- `data/AGB_cleaned` is where data files for each of the data products
  should be placed in order to reproduce this workflow. Copy this folder
  from the “snow” server.
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
