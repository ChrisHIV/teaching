// We model a set of observations as normally distributed below some known
// truncation threshold above which we can't observe any values,
// together with the count for the number of values that could not be observed
// because they were over this threshold.
// We estimate the mean mu and standard deviation sigma of the normal.

data {
  int<lower = 1> num_y_observed;
  real y[num_y_observed];
  real y_max;
  int<lower = 0> num_y_truncated;
  
  // A boolean switch for whether we sample from the
  // posterior or the prior, to see how and how much the data are updating our
  // beliefs about the parameters and the kind of data they generate.
  // 0 for prior, 1 for posterior
  int<lower = 0, upper = 1> get_posterior_not_prior;
}

parameters {
  real<lower = -10, upper = 10> mu;
  real<lower = 0, upper = 10> sigma;
}

model {
  
  // Priors not implicitly defined by the ranges stated at parameter declaration 
  // should be defined here. 
  
  // Calculate the likelihood if desired.
  // It has probability density contributions from the observed y
  // values and probability mass contributions from the truncated ones - for the
  // latter we integrate the probability density over all values over the
  // threshold.
  if (get_posterior_not_prior) {
    y ~ normal(mu, sigma);
    target += num_y_truncated * normal_lccdf(y_max | mu, sigma);
  }
}
