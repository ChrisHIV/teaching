# PRELIMINARIES ----------------------------------------------------------------
#
# Authors: Rob Hinch and Chris Wymant
# Acknowledgment: written while funded by a Li Ka Shing Foundation grant 
# awarded to Christophe Fraser.
#
# Abbreviations:
# df = dataframe
# num = number
# mcmc = Markov Chain Monte Carlo
# param = parameter
# mu = the meanlog param of a lognormal
# sigma = the sdlog param of a lognormal
#
# Script purpose: we simulate a set of values y from either a 'signal'
# distribution or a 'noise' distribution, both lognormals but with different
# params, and then get Stan to infer the params of those distributions
# and which values were signal and which were noise. See the comments in the
# Stan code for how that works.

library(tidyverse)
library(rstan)
options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

# INPUT ------------------------------------------------------------------------
 
# The path of the Stan code associated with this R code
file_input_stan_code <- 
  "~/teaching/other_topics/estimate_binary_vector.stan"

# Population-level params for the simulation
num_observations <- 1000
fraction_signal <- 0.8
mu_signal <- 10
sigma_signal <- 3
mu_noise <- 3
sigma_noise <- 0.8

# SIMULATE DATA ----------------------------------------------------------------

df <- tibble(
  is_signal = rbernoulli(num_observations, fraction_signal),
  y_observed = if_else(is_signal,
                        rlnorm(num_observations, mu_signal, sigma_signal),
                        rlnorm(num_observations, mu_noise,  sigma_noise)))

# RUN STAN ---------------------------------------------------------------------

stan_input_posterior <- list(
  num_observations = nrow(df),
  y = df$y_observed,
  prior_mu_signal_min = 7,
  prior_mu_signal_max = 15,
  prior_sigma_signal_min = 0.5,
  prior_sigma_signal_max = 5,
  prior_mu_noise_min = 1,
  prior_mu_noise_max = 6,
  prior_sigma_noise_min = 0.5,
  prior_sigma_noise_max = 5,
  prior_fraction_signal_min = 0,
  prior_fraction_signal_max = 1,
  get_posterior_not_prior = 1L
)
stan_input_prior <- stan_input_posterior
stan_input_prior$get_posterior_not_prior <- 0L

# Compile the Stan code
model_compiled <- stan_model(file_input_stan_code)

# Run the Stan code to sample from both posterior and prior
num_mcmc_iterations <- 500
num_mcmc_chains <- 4
start_time <- Sys.time()
fit <- sampling(model_compiled,
                data = stan_input_posterior,
                iter = num_mcmc_iterations,
                chains = num_mcmc_chains)
fit_prior <- sampling(model_compiled,
                      data = stan_input_prior,
                      iter = num_mcmc_iterations,
                      chains = num_mcmc_chains)
end_time <- Sys.time()
cat("Time taken running Stan:\n")
end_time - start_time

# ANALYSE STAN OUTPUT ----------------------------------------------------------

# Get stan output into a long df labelled by posterior/prior
df_fit <- bind_rows(fit %>%
                      as.data.frame() %>% 
                      mutate(density_type = "posterior",
                             sample = row_number()),
                    fit_prior %>% 
                      as.data.frame() %>%
                      mutate(density_type = "prior",
                             sample = row_number())) %>%
  as_tibble() %>%
  pivot_longer(-c("sample", "density_type"), names_to = "param")

# Plot the prior and posterior for population-level (not for specific 
# observations) params and the simulation truth
df_params_true <- tibble(
  param = c("fraction_signal", "mu_signal", "sigma_signal", "mu_noise",
            "sigma_noise"),
  value = c(fraction_signal, mu_signal, sigma_signal, 
            mu_noise, sigma_noise))
ggplot(df_fit %>%
  filter(!startsWith(param, "lp"),
         !startsWith(param, "prob_is_noise_given_params"))) +
  geom_histogram(aes(value, y = ..density.., fill = density_type),
                 alpha = 0.6,
                 position = "identity",
                 bins = 60) +
  geom_vline(data = df_params_true, aes(xintercept = value), color = "black") +
  facet_wrap(~param, scales = "free", nrow = 3) +
  scale_fill_brewer(palette = "Set1") +
  theme_classic() +
  coord_cartesian(expand = FALSE) +
  labs(fill = "",
       x = "param value",
       y = "probability density")

# Calculate the posterior means for each observation's probability of 
# being noise. Link observations to their simulation truth. Binarise the
# means and compare against whether they really were noise.
df_fit %>% 
  filter(startsWith(param, "prob_is_noise_given_params"),
         density_type == "posterior") %>%
  group_by(param) %>%
  summarise(mean_prob_is_noise = mean(value), .groups = "drop") %>%
  mutate(which_observation =
           str_match(param, "^prob_is_noise_given_params\\[([0-9]+)\\]$")[, 2] %>%
           as.integer()) %>%
  left_join(df %>% mutate(which_observation = row_number()),
            by = "which_observation") %>%
  mutate(correctly_classified = (mean_prob_is_noise < 0.5 & is_signal) |
           (mean_prob_is_noise > 0.5 & ! is_signal)) %>%
  summarise(fraction_correctly_classified = sum(correctly_classified) / n())
  

