
stan_data_sp1 <- function(data) {
sp1 <- data %>% mutate(LMA = dry_weight/(disc*pi*(0.005)^2))%>% 
    filter(species == "Melastoma_candidum")
x <- cbind(1,
          log(1/(sp1$Distance)^2) |> scale(),
          scale(sp1$canopy_openness))

x <- cbind(x, x[,2] * x[,3])

list(
  N = nrow(sp1),
  J = sp1$individual |> unique() |> length(),
  K = 4,
  ind = sp1$individual,
  x = x,
  y = log(sp1$LMA))
}

stan_data_sp2 <- function(data) {
sp2 <- data %>% mutate(LMA = dry_weight/(disc*pi*(0.005)^2))%>% 
    filter(species == "Colocasia_gigantea")
x <- cbind(1,
          log(1/(sp2$Distance)^2) |> scale(),
          scale(sp2$canopy_openness))

x <- cbind(x, x[,2] * x[,3])

list(
  N = nrow(sp2),
  J = sp2$individual |> unique() |> length(),
  K = 4,
  ind = sp2$individual,
  x = x,
  y = log(sp2$LMA))
}

