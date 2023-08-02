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
  "knitr",
  "cowplot",
  "magick",
  "latex2exp"
))

# check if it's inside a container
if (file.exists("/.dockerenv") | file.exists("/.singularity.d/startscript")) {
  Sys.setenv(CMDSTAN = "/opt/cmdstan/cmdstan-2.32.2")
  set_cmdstan_path("/opt/cmdstan/cmdstan-2.32.2")
}

cmdstan_version()

mapped <- tar_map(
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
        ~posterior::quantile2(.x, probs = c(0.025, 0.05, 0.25, 0.5, 0.75,0.8,0.85,0.9, 0.95, 0.975)),
        posterior::default_convergence_measures()
      )
    ),
    tar_target(
      summary_stan_each, {
        fit_summary_model |>
        filter(str_detect(variable, "beta")) |>
        filter(!str_detect(variable, "beta\\[1,")) |>
        mutate(sp = sp)
      }
    )
  )

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
        width = 110,
        height = 57.7,
        units = "mm"
      )
    },
    format = "file"
  ),
  mapped,
  tar_combine(
    summary_stan,
    mapped[["summary_stan_each"]],
    command = bind_rows(!!!.x)
  ),
  tar_target(
    table,{
    Tb <- table_summary(summary_stan)
    my_kable_save(
      Tb,
      "figs/Table1"
    )
    },  
  ),
  tar_target(
    daylight_jpg,
    "figs/daylight.jpg",
    format = "file"
  ),
  tar_target(
    night_jpg,
    "figs/night.jpg",
    format = "file"
  ),
  #tar_target(
  #  plot_merge,
  #  plot_merge(daylight_jpg,night_jpg,
  #    "figs/merge",
  #    110,
  #    57)
  #),
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
