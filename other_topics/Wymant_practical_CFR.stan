// Inference of the case fatality ratio (CFR) from time series of daily new 
// cases and deaths, with deaths lagging behind cases by some known negative 
// binomial distribution.
// 
// We calculate the number of deaths expected each day given the number of cases
// until that day, by multiplying the number of cases on some previous day
// (t days ago say) by the probability that each of them dies (the CFR) and the
// probability that the death has a delay of t (conditional upon dying), and
// summing this over t.
// We then model the observered deaths as Poisson distributed around their
// expectation.

data {
  int<lower = 1> num_days;
  array[num_days] int<lower = 0> new_cases;  // time series of daily cases
  array[num_days] int<lower = 0> new_deaths; // time series of daily deaths
  // mean and variance of the distribution from becoming a case to dying:
  real<lower = 0> death_delay_mean; 
  real<lower = death_delay_mean> death_delay_var;
}

transformed data {
  // Get the alpha and beta parameters for this mean and variance (negative
  // binomial distribution).
  real death_delay_beta = death_delay_mean / (death_delay_var - death_delay_mean);
  real death_delay_alpha = death_delay_mean * death_delay_beta;
}

parameters {
  real<lower = 0, upper = 1> cfr; 
}

transformed parameters {
  vector[num_days] new_deaths_expected = rep_vector(0, num_days);
  for (day_case in 1:num_days) {
    for (day_death in day_case:num_days) {
      new_deaths_expected[day_death] = new_deaths_expected[day_death] +
      new_cases[day_case] * cfr * exp(neg_binomial_lpmf(
      day_death - day_case | death_delay_alpha, death_delay_beta));
    }
  }
}

model {
  new_deaths ~ poisson(new_deaths_expected);
}

// Simulate new values of the modelled data (deaths) for a posterior
// retrodictive check
generated quantities {
  array[num_days] int new_deaths_simulated = poisson_rng(new_deaths_expected);
}
