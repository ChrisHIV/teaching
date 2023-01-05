# We simulate a set of observations as normally distributed below some known
# truncation threshold above which we can't observe any values.
# We estimate the mean mu and standard deviation sigma of the normal.

library(tidyverse)
library(rstan)
options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

# INPUT ------------------------------------------------------------------------

# Replace this by your local path to the associated Stan code
file_input_stan_code <- "~/Dropbox (Infectious Disease)/STAN/continuous_truncated_variable_mixed_likelihood_density_mass.stan"

mu <- 3
sigma <- 1
y_max <- 2.5
N <- 1000

# SIMULATE DATA ----------------------------------------------------------------

y <- rnorm(N, mu, sigma)
y_truncated <- y[y < y_max]
num_truncated <- N - length(y_truncated)

hist(c(y_truncated, rep(y_max + 2, num_truncated)), breaks = 50)


# RUN STAN ---------------------------------------------------------------------

stan_input_posterior <- list(
  num_y_observed = length(y_truncated),
  y = y_truncated,
  y_max = y_max,
  num_y_truncated = num_truncated,
  get_posterior_not_prior = 1L
)
stan_input_prior <- stan_input_posterior
stan_input_prior$get_posterior_not_prior <- 0L

# Compile the Stan code
model_compiled <- stan_model(file_input_stan_code)

# Run the Stan code
num_mcmc_iterations <- 1000
num_mcmc_chains <- 4
fit <- sampling(model_compiled,
                data = stan_input_posterior,
                iter = num_mcmc_iterations,
                chains = num_mcmc_chains)
fit_prior <- sampling(model_compiled,
                      data = stan_input_prior,
                      iter = num_mcmc_iterations,
                      chains = num_mcmc_chains)

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

df_params_true <- tibble(
  param = c("mu", "sigma"),
  value = c(mu, sigma))
ggplot(df_fit %>% filter(param != "lp__")) +
  geom_histogram(aes(value, y = ..density.., fill = density_type),
                 alpha = 0.6,
                 position = "identity",
                 bins = 100) +
  geom_vline(data = df_params_true, aes(xintercept = value), color = "black") +
  facet_wrap(~param, scales = "free", nrow = 1) +
  scale_fill_brewer(palette = "Set1") +
  theme_classic() +
  coord_cartesian(expand = FALSE) +
  labs(fill = "",
       x = "param value",
       y = "probability density")
ggsave("continuous_truncated_variable_mixed_likelihood_density_mass.pdf", height = 4, width = 9)
