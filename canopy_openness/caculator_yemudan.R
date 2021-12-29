tempdir <- function() "D:/R"
unlockBinding("tempdir", baseenv())
utils::assignInNamespace("tempdir", tempdir, ns="base", envir=baseenv())
assign("tempdir", tempdir, baseenv())
lockBinding("tempdir", baseenv())
tempfile()

library(LeafArea)
library(tidyverse)
?run.ij
res <- run.ij(path.imagej = 'E:/ImageJ',
              set.directory = 'D:/light_project/100NIKON_yemudan', # path to images
              distance.pixel = 2272,
              known.distance = 2272,
              trim.pixel = 0,
              save.image = TRUE ,
              check.image = FALSE)
res0 <- res |>
  # rectangle - dark_area
  mutate(white = 2272 * 1704 - total.leaf.area) |>
  mutate(canopy_opennes = white / (830^2 *pi))
res0
?write.csv
write.csv(res0,file = 'D:/light_project/cannopy_openness_yemudan.csv')
