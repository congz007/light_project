library(targets)
library(stantargets)

source("R/make_table.R")


tar_option_set(packages = c(
  "tidyverse",
  "ggpubr",
  "here",
  "rstan",
  "bayesplot",
  "cowplot",
  "kableExtra",
  "knitr"
))

list(
    tar_target(table_data, 
        read_csv("data/table.csv")
        ),
    tar_target(table,
        make_table(table_data)
    )
)
