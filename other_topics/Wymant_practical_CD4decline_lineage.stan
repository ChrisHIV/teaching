// Author: Chris Wymant

// Acknowledgment: I wrote this while funded by ERC Advanced Grant PBDR-339251
// and a Li Ka Shing Foundation grant, both awarded to Christophe Fraser.

// Abbreviations:
// cat = category
// ref = reference (the reference cat)
// pat = patient
// sd = standard deviation
// inter = intercept
// param = parameter
// num = number

// Model desciption:
// We model cd4 values observed at different times (since diagnosis) for 
// different individuals with different characteristics, via 
// cd4 ~ N(inter + time * slope, error sd)
// inter and slope vary between individuals, by fixed effects determined by a 
// 0-or-1 design matrix specifying categorical predictors, and by 
// random effects for the specific individual 
// in question, i.e. we model a per-individual effect that comes from a normal 
// distribution whose sd we estimate. All the effects interact additively to 
// determine the overall inter and slope for each individual.


data {
  
  // ACTUAL DATA
  
  int<lower = 1> num_data; // number of observations (i.e. rows)
  int<lower = 2> num_pats;
  
  // The total number of non-ref cats, summed over all categorical variables, 
  // used for predicting the inter and slope
  int<lower = 1> num_predictors_for_inter;
  int<lower = 1> num_predictors_for_slope;
  
  // Aspects of each observation (i.e. columns)
  vector<lower = 0>[num_data] cd4; 
  vector[num_data] time; // time since diagnosis
  matrix<lower = 0, upper = 1>[num_data, num_predictors_for_inter] design_matrix_for_inter;
  matrix<lower = 0, upper = 1>[num_data, num_predictors_for_slope] design_matrix_for_slope;
  int<lower = 1, upper = num_pats> pat[num_data]; 
  
  // PRIOR/POSTERIOR SWITCH
  
  // do we multiply the prior by the likelihood (1, giving the posterior) or not (0)?
  int<lower = 0, upper = 1> calculate_likelihood;
  
  // PARAMS OF THE PRIORS FOR THE ESTIMATED PARAMS
  
  real min_of_prior_for_slope_ref;
  real max_of_prior_for_slope_ref;
  real<lower = 0> min_of_prior_for_inter_ref;
  real<lower = 0> max_of_prior_for_inter_ref;
  
  real min_of_prior_for_beta_inter;
  real max_of_prior_for_beta_inter;
  real min_of_prior_for_beta_slope;
  real max_of_prior_for_beta_slope;

  real min_of_prior_for_sd_error;
  real max_of_prior_for_sd_error;
  real<lower = 0> min_of_prior_for_slope_pat_scale;
  real<lower = min_of_prior_for_slope_pat_scale> max_of_prior_for_slope_pat_scale;
  real<lower = 0> min_of_prior_for_inter_pat_scale;
  real<lower = min_of_prior_for_inter_pat_scale> max_of_prior_for_inter_pat_scale;
  
}

transformed data {
  vector[2] zeros[num_pats]; 
  for (i in 1:num_pats) zeros[i] = rep_vector(0, 2);
}

parameters {

  real<lower = min_of_prior_for_slope_ref, upper = max_of_prior_for_slope_ref> slope_ref;
  real<lower = min_of_prior_for_inter_ref, upper = max_of_prior_for_inter_ref> inter_ref;

  vector<lower = min_of_prior_for_beta_inter,
    upper = max_of_prior_for_beta_inter>[num_predictors_for_inter] beta_inter;
  vector<lower = min_of_prior_for_beta_slope,
    upper = max_of_prior_for_beta_slope>[num_predictors_for_slope] beta_slope;

  real<lower = min_of_prior_for_sd_error, upper = max_of_prior_for_sd_error> sd_error;
  real<lower = min_of_prior_for_slope_pat_scale, upper = max_of_prior_for_slope_pat_scale> slope_pat_scale;
  real<lower = min_of_prior_for_inter_pat_scale, upper = max_of_prior_for_inter_pat_scale> inter_pat_scale;
  // For each pat, a 2-component vector containing their random effects on inter
  // and slope, normalised to 1 i.e. before scaling by the two parameters 
  // controlling between-pat variability:
  vector[2] inter_and_slope_per_pat_unscaled[num_pats];
  // The dimensionless correlation coefficient between the inter and slope
  // random effects
  real<lower=-1, upper=1> rho; // 

}

transformed parameters {

  corr_matrix[2] Rho;
  vector[num_data] cd4_expected;
  
  Rho[1, 1] = 1;
  Rho[2, 2] = 1;
  Rho[1, 2] = rho;
  Rho[2, 1] = rho;

  // Define the expected cd4 count for each observation, as
  // inter + time * slope, where inter and slope each receive additive
  // contributions from the predictors associated with this observation.
  cd4_expected = inter_ref + slope_ref * time +
    design_matrix_for_inter * beta_inter +
    design_matrix_for_slope * beta_slope .* time;
  for (i in 1:num_data) {
    cd4_expected[i] = cd4_expected[i] +
      inter_and_slope_per_pat_unscaled[pat[i], 1] * inter_pat_scale +
      time[i] * inter_and_slope_per_pat_unscaled[pat[i], 2] * slope_pat_scale;
  }

}

model {
  
  // Priors
  inter_and_slope_per_pat_unscaled ~ multi_normal(zeros, Rho);
  
  // Normal likelihood for observations given what's expected
  if (calculate_likelihood == 1) {
    cd4 ~ normal(cd4_expected, sd_error);
  }
  
}

generated quantities {
  real cd4_simulated[num_data];
  cd4_simulated = normal_rng(cd4_expected, sd_error);
}
