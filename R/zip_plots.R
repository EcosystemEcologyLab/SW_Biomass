zip_plots <- function(plot_files, zipfile) {
  zip(zipfile, files = plot_files)
  zipfile
}
