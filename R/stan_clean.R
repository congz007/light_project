generate_stan_data <- function(lma_df,
  sp = c("Melastoma_candidum", "Colocasia_gigantea")) {
  lma_df <- lma_df |>
    mutate(lma = dry_weight / (disc * pi * (0.005)^2)) |>
    filter(sp == {{sp}})

  x <- cbind(
    1,
    log(1 / (lma_df$distance)^2) |> scale(),
    scale(lma_df$canopy_openness)
  )
  x <- cbind(x, x[,2] * x[,3])

list(
  N = nrow(lma_df),
  J = lma_df$individual |> unique() |> length(),
  K = 4,
  ind = lma_df$individual,
  x = x,
  y = log(lma_df$lma))
}
