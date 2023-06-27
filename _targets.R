library(targets)
library(tarchetypes)
library(stantargets)
library(cmdstanr)
library(furrr)

source("R/make_table.R")
source("R/geo_dis.R")
source("R/stan_clean.R")

plan(multicore)
options(clustermq.scheduler = "multicore")

tar_option_set(packages = c(
  "tidyverse",
  "here",
  "bayesplot",
  "patchwork",
  "kableExtra",
  "knitr"
))

# check if it's inside a container
if (file.exists("/.dockerenv") | file.exists("/.singularity.d/startscript")) {
  Sys.setenv(CMDSTAN = "/opt/cmdstan/cmdstan-2.32.2")
  set_cmdstan_path("/opt/cmdstan/cmdstan-2.32.2")
}

cmdstan_version()

list(
  tar_target(
    leaf_light_project_csv,
    "data/leaf_light_project.csv",
    format = "file"
  ),
  # tar_target(
  #   table_csv,
  #   "data/table_csv",
  #   format = "file"
  # ),
  tar_target(
    lma_df,
    read_csv(leaf_light_project_csv) |>
      janitor::clean_names() |>
      mutate(sp = ifelse(species == "Melastoma_candidum", "melas", "coloc")) |>
      mutate(lma = dry_weight / (disc * pi * (0.005)^2))
  ),
  tar_target(
      lma_map,{
      p <- plot_geo(lma_df)
      my_ggsave(
        "figs/lma_map",
        p,
        dpi = 300,
        width = 173,
        height = 57.7,
        units = "mm"
      )
    },
    format = "file"
  ),
  tar_map(
    values = list(sp = c("melas", "coloc")),
    tar_target(
      stan_data,
      generate_stan_data(lma_df, sp)
    ),
    tar_stan_mcmc(
      fit,
      "stan/model.stan",
      data = stan_data,
      refresh = 0,
      chains = 4,
      parallel_chains = getOption("mc.cores", 4),
      iter_warmup = 1000,
      iter_sampling = 2000,
      adapt_delta = 0.95,
      max_treedepth = 15,
      seed = 123,
      return_draws = TRUE,
      return_diagnostics = TRUE,
      return_summary = TRUE,
      summaries = list(
        mean = ~mean(.x),
        sd = ~sd(.x),
        mad = ~mad(.x),
        ~posterior::quantile2(.x, probs = c(0.025, 0.05, 0.25, 0.5, 0.75, 0.95, 0.975)),
        posterior::default_convergence_measures()
      )
    )
  ),
  # tar_target(table_data,
  #     read_csv("data/table.csv")
  #     ),
  # tar_target(table,
  #     make_table(table_data)
  # ),
  # tar_target(data,
  #     read_csv("data/leaf_light_project.csv")
  # ),
  # tar_target(fig1,
  #     plot_geo(data)
  # ),
#   tar_target(sp1,
#       stan_data_sp1(data)
#   ),
#   tar_stan_mcmc(
#   fit_sp1,
#   "stan/model.stan",
#   data = sp1,
#   refresh = 200,
#   chains = 4,
#   thin = 1,
#   parallel_chains = getOption("mc.cores", 4),
#   iter_warmup = 1000,
#   iter_sampling = 1000,
#   seed = 123
#  ),
#   tar_target(sp2,
#       stan_data_sp2(data)
#   ),
#   tar_stan_mcmc(
#   fit_sp2,
#   "stan/model.stan",
#   data = sp2,
#   refresh = 200,
#   chains = 4,
#   thin = 1,
#   parallel_chains = getOption("mc.cores", 4),
#   iter_warmup = 1000,
#   iter_sampling = 1000,
#   seed = 123
#  ),
 NULL
)
