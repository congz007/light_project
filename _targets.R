library(targets)
library(stantargets)
library(cmdstanr)

source("R/make_table.R")
source("R/geo_dis.R")
source("R/stan_clean.R")

set_cmdstan_path("/home/cong/.cmdstan/cmdstan-2.32.2")
cmdstan_version()

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
    ),
    tar_target(data,
        read_csv("data/leaf_light_project.csv")
    ),
    tar_target(fig1,
        plot_geo(data)
    ),
    tar_target(sp1,
        stan_data_sp1(data)
    ),
    tar_stan_mcmc(
    fit_sp1,
    "stan/model.stan",
    data = sp1,
    refresh = 200,
    chains = 4,
    thin = 1,
    parallel_chains = getOption("mc.cores", 4),
    iter_warmup = 1000,
    iter_sampling = 1000,
    seed = 123
   ),
    tar_target(sp2,
        stan_data_sp2(data)
    ),
    tar_stan_mcmc(
    fit_sp2,
    "stan/model.stan",
    data = sp2,
    refresh = 200,
    chains = 4,
    thin = 1,
    parallel_chains = getOption("mc.cores", 4),
    iter_warmup = 1000,
    iter_sampling = 1000,
    seed = 123
   )
)
