data{
  int<lower=0> N; // number of sample
  int<lower=1> J; // number of individual
  int<lower=1> K; // number of parameters
  matrix[N, K] x; // tree-level predictor
  vector[N] y; //log(LMA)
  int<lower=1,upper=J> ind[N]; // integer
}


parameters{
  matrix[K,1] beta;
  vector[J] phi_raw;
  real<lower=0,upper=pi()/2> tau_unif;
  real<lower=0> sigma;
}

transformed parameters{
  real<lower=0> tau;
  vector[J] phi;
  tau = 2.5 * tan(tau_unif); // implies tau ~ cauchy(0, 2.5)
  phi = phi_raw * tau;
}

model {
  //vector[N] mu;
  //for (n in 1:N) mu[n] = x[n, ] * beta + phi[ind[n]];
  phi_raw ~ std_normal();
  to_vector(beta) ~ normal(0, 5);
  y ~ normal(to_vector(x * beta) + phi[ind], sigma);
}
