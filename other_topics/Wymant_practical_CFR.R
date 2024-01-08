library(tidyverse)
library(binom)
library(rstan)
theme_set(theme_classic())
rstan_options(auto_write = TRUE) # helpful options for stan
options(mc.cores = parallel::detectCores()) # helpful options for stan

# Change to what's appropriate for you
setwd("~/Dropbox (Infectious Disease)/talks_mine_misc/2023-01_StatsLectureAndPractical/Canvas/")

# LOAD AND WRANGLE REAL DATA ---------------------------------------------------

# Read in daily COVID-19 case and death data from the WHO
df <- read_csv("WHO-COVID-19-global-data.csv")

# Restrict to the desired country and period
df <- df %>%
  filter(Country_code == "GB",
         Date_reported <= "2020-04-10")

# For convenience discard irrelevant columns, and dates before any cases
df <- df %>%
  select(-c("Country_code", "Country", "WHO_region")) %>%
  filter(Cumulative_cases > 0)

# Visualise the growth of daily cases and deaths 
ggplot(df) +
  geom_point(aes(Date_reported, New_deaths)) +
  scale_y_log10()
ggplot(df) +
  geom_point(aes(Date_reported, New_cases)) +
  scale_y_log10()

# THE MOST NAIVE CFR ESTIMATION, REAL DATA -------------------------------------
 
df <- df %>%
  mutate(cfr_naive = Cumulative_deaths / Cumulative_cases)

# Add 95% frequentist CIs (calculated according to one method; there are several)
cfr_naive_confints <-
  binom.confint(df$Cumulative_deaths, df$Cumulative_cases, method = "exact")
df$cfr_naive_lower <- cfr_naive_confints$lower
df$cfr_naive_upper <- cfr_naive_confints$upper

# Plot
ggplot(df) +
  geom_point(aes(Date_reported, cfr_naive)) +
  geom_errorbar(aes(Date_reported, 
                    ymin = cfr_naive_lower,
                    ymax = cfr_naive_upper))
  
# SIMULATE DATA ----------------------------------------------------------------

# Choose parameter values
t_doubling <- 3 # in units of days
cfr_true <- 0.1
death_delay_mean <- 5
death_delay_var  <- 10 # must be greater than the mean
# don't make num_days too large, or the exponentially growing number of cases 
# will make subsequent code take a lot of memory:
num_days <- 40 

# Calculate derived parameters
exponential_growth_rate <- log(2) / t_doubling
death_delay_size <- death_delay_mean^2 / (death_delay_var - death_delay_mean)

# Check that our death delay distribution is parameterised as we intended.
# The range of values for 'delay' will need to be increased if death_delay_mean
# and/or death_delay_var are made large.
df_test_delay <- tibble(delay = 0:100, 
                        prob = dnbinom(x = delay,
                                    mu = death_delay_mean,
                                    size = death_delay_size))
# This should equal death_delay_mean:
df_test_delay %>%
  mutate(mean_contribution = prob * delay) %>%
  pull(mean_contribution) %>%
  sum
# This should equal death_delay_var:
df_test_delay %>%
  mutate(variance_contribution = prob * (delay - death_delay_mean)^2) %>%
  pull(variance_contribution) %>%
  sum

# Simulate cases each day
df_sim <- tibble(t = 1:num_days,
                 New_cases_expected = exp(exponential_growth_rate * t),
                 New_cases = rpois(n = num_days, lambda = New_cases_expected),
                 Cumulative_cases = cumsum(New_cases))

# Exclude days before cases start, for convenience of avoiding NaN CFR values.
# Redefine t to start from 1.
df_sim <- df_sim %>%
  filter(Cumulative_cases > 0)
num_days <- nrow(df_sim)
df_sim$t <- 1:num_days

# Plot
ggplot(df_sim) +
  geom_point(aes(t, New_cases)) +
  scale_y_log10()

# For all cases, get the time at which they became a case
times_of_new_cases <- df_sim %>%
  uncount(New_cases) %>% # duplicate each row 'New_cases' times
  pull(t)

# For all cases, randomly draw their delay to death if they were to die (some
# don't die)
num_cases_total <- df_sim$Cumulative_cases[[num_days]]
death_delays <- rnbinom(n = num_cases_total,
                        mu = death_delay_mean,
                        size = death_delay_size)

# Add the delay-to-death (if they were to die) to the time at which they became 
# a case, to get their time of death (if they were to die)
times_of_deaths <- times_of_new_cases + death_delays

# For all cases, randomly draw whether they actually die
case_i_died <- rbernoulli(num_cases_total, p = cfr_true)

# Select the subset of times_of_deaths that are only for those cases that 
# actually die
times_of_deaths <- times_of_deaths[case_i_died]

# Remove any times_of_deaths that occur after the end of our simulation
times_of_deaths <- times_of_deaths[times_of_deaths <= num_days]

# Count the number of deaths each day...
df_sim_deaths <- table(times_of_deaths) %>%
  as.data.frame() %>%
  rename(t = times_of_deaths,
         New_deaths = Freq) %>%
  mutate(t = t %>% as.character %>% as.integer)

# ...and merge that into df_sim
df_sim <- df_sim %>%
  left_join(df_sim_deaths, by = "t") %>%
  replace_na(list(New_deaths = 0L)) %>%
  mutate(Cumulative_deaths = cumsum(New_deaths))

# THE MOST NAIVE CFR ESTIMATION, SIMULATED DATA --------------------------------

cfr_naive_confints <- binom.confint(df_sim$Cumulative_deaths, 
                                    df_sim$Cumulative_cases, 
                                    method = "exact")
df_sim$cfr_naive <- cfr_naive_confints$mean
df_sim$cfr_naive_lower <- cfr_naive_confints$lower
df_sim$cfr_naive_upper <- cfr_naive_confints$upper

# Plot, with a horizontal line for the true value
ggplot(df_sim) +
  geom_point(aes(t, cfr_naive)) +
  geom_errorbar(aes(t, 
                    ymin = cfr_naive_lower,
                    ymax = cfr_naive_upper)) +
  geom_hline(yintercept = cfr_true, color = "blue")

# THE CFR APPROACH OF BAUD ET AL -----------------------------------------------

df_sim_censored <- df_sim %>%
  mutate(Cumulative_cases_censored =
           lag(Cumulative_cases, round(death_delay_mean))) %>%
  filter(!is.na(Cumulative_cases_censored))

cfr_baud_confints <- binom.confint(df_sim_censored$Cumulative_cases_censored, 
                                    df_sim_censored$Cumulative_cases, 
                                    method = "exact")
df_sim_censored$cfr_baud <- cfr_baud_confints$mean
df_sim_censored$cfr_baud_lower <- cfr_baud_confints$lower
df_sim_censored$cfr_baud_upper <- cfr_baud_confints$upper

# Plot, with a horizontal line for the true value
ggplot(df_sim_censored) +
  geom_point(aes(t, cfr_baud)) +
  geom_errorbar(aes(t, 
                    ymin = cfr_baud_lower,
                    ymax = cfr_baud_upper)) +
  geom_hline(yintercept = cfr_true, color = "blue")

# LIKELIHOOD-BASED INFERENCE, SIMULATED DATA -----------------------------------

stan_input <- list(
  num_days = num_days,
  new_cases = df_sim$New_cases,
  new_deaths = df_sim$New_deaths,
  death_delay_mean = death_delay_mean,
  death_delay_var = death_delay_var
)


# Compile the Stan model
stan_file <- "practical_CFR.stan"
model_compiled <- stan_model(stan_file)

# Stan parameters
num_mcmc_iterations <- 1000
num_mcmc_chains <- 4

# Run the Stan code
start_time <- Sys.time()
cat("Started running Stan at ")
print(start_time)
fit_posterior <- sampling(model_compiled,
                          data = stan_input,
                          iter = num_mcmc_iterations,
                          chains = num_mcmc_chains,
                          pars = c("cfr", "new_deaths_simulated"))
end_time <- Sys.time()
cat("Running Stan:\n")
end_time - start_time

df_fit_wide <- fit_posterior %>%
  as.data.frame() %>% 
  mutate(sample = row_number()) 

ggplot(df_fit_wide) +
  geom_histogram(aes(cfr)) +
  geom_vline(xintercept = cfr_true) +
  coord_cartesian(expand = F)

# Posterior retrodictive check: simulate new data, including both epistemological
# uncertainty (in the parameters) and ontological uncertainty (i.e. inherent,
# stochastic uncertainty, the unexplained variability in our likelihood),
# and see where the actual data lies in that distribution. This lets us see how
# the model fits the data.
df_fit_wide %>%
  pivot_longer(-sample, names_to = "param") %>%
  filter(str_detect(param, "new_deaths_simulated\\[[0-9]+\\]")) %>%
  tidyr::extract(param, 
                 into = c("day"), 
                 regex = "new_deaths_simulated\\[([0-9]+)\\]") %>%
  mutate(day = as.integer(day),
         value = value + 1) %>% # add 1 to allow plotting on a log scale
  rename(`new daily deaths +1` = value) %>%
  ggplot() +
  geom_violin(aes(x = day, y = `new daily deaths +1`, group = day)) +
  geom_point(data = df_sim %>% mutate(New_deaths = New_deaths + 1),
             aes(x = t, y = New_deaths), colour = "blue") +
  scale_y_log10()

# LIKELIHOOD-BASED INFERENCE, REAL DATA ----------------------------------------

stan_input <- list(
  num_days = nrow(df),
  new_cases = df$New_cases,
  new_deaths = df$New_deaths,
  death_delay_mean = 12,
  death_delay_var = (12 * 0.85)^2
)

# Compile the Stan model
stan_file <- "practical_CFR.stan"
model_compiled <- stan_model(stan_file)

# Stan parameters
num_mcmc_iterations <- 1000
num_mcmc_chains <- 4

# Run the Stan code
start_time <- Sys.time()
cat("Started running Stan at ")
print(start_time)
fit_posterior <- sampling(model_compiled,
                          data = stan_input,
                          iter = num_mcmc_iterations,
                          chains = num_mcmc_chains,
                          pars = c("cfr", "new_deaths_simulated"))
end_time <- Sys.time()
cat("Running Stan:\n")
end_time - start_time

df_fit_wide <- fit_posterior %>%
  as.data.frame() %>% 
  mutate(sample = row_number()) 

ggplot(df_fit_wide) +
  geom_histogram(aes(cfr)) +
  coord_cartesian(expand = F)

# Posterior retrodictive check: simulate new data, including both epistemological
# uncertainty (in the parameters) and ontological uncertainty (i.e. inherent,
# stochastic uncertainty, the unexplained variability in our likelihood),
# and see where the actual data lies in that distribution. This lets us see how
# the model fits the data.
df_fit_wide %>%
  pivot_longer(-sample, names_to = "param") %>%
  filter(str_detect(param, "new_deaths_simulated\\[[0-9]+\\]")) %>%
  tidyr::extract(param, 
                 into = c("day"), 
                 regex = "new_deaths_simulated\\[([0-9]+)\\]") %>%
  mutate(day = as.integer(day),
         value = value + 1) %>% # add 1 to allow plotting on a log scale
  rename(`new daily deaths +1` = value) %>%
  ggplot() +
  geom_violin(aes(x = day, y = `new daily deaths +1`, group = day)) +
  geom_point(data = df %>% mutate(New_deaths = New_deaths + 1,
                                      t = row_number()),
             aes(x = t, y = New_deaths), colour = "blue") +
  scale_y_log10()
