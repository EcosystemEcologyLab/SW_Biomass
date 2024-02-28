#rsync data with jetstream2 instance mounted volume
#recommend sourcing as background job since this may take a loooooong time
library(fs)
library(targets)
library(tidyverse)

file_targets <-
  targets::tar_manifest(c(ends_with("_dir"), ends_with("_file"), ends_with("_files")))

paths_local <- 
  map(file_targets$name, \(x) {
    do.call(tar_read, args = list(name = x))
  }) |> list_c()

#test with just shapfiles that aren't already on jestream2
# paths_local <- paths_local[str_detect(paths_local, "shapefiles")]

#write file paths to tempfile
file_list <- fs::file_temp()
writeLines(paths_local, file_list)

#rsync rasters to jetstream mounted volume
dir_remote <- "/media/volume/agb_rasters"
dst <- paste("exouser@149.165.175.200", dir_remote, sep = ":")
args <- c("-az", #-a archive mode, -z compress files
          "--partial", # keep partial transfers in case of interruptions
          "--info=progress2", #output progress for the whole transfer
          "--info=name0", #don't show the filename though
          "--stats", #print stats at the end of the transfer
          paste0("--files-from=", file_list),"./", #transfer these specific files
          dst) 

processx::run("rsync", args = args, echo_cmd = TRUE, stdout = "", spinner = TRUE)
