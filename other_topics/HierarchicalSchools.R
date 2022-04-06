# PRELIMINARIES ----------------------------------------------------------------
library(tidyverse)
library(ggforce) # just for one plot
library(rstan)
library(lme4)
options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

set.seed(1)

file_input_stan_code <- "~/Dropbox (Infectious Disease)/STAN/HierarchicalSchools.stan"
file_output_plot_params <- "~/HierarchicalSchools.pdf"
file_output_plot_data <- "~/HierarchicalSchoolsData.pdf"

num_students <- 1000
num_schools <- 10
stddev_students <- 10
stddev_schools <- 5
grade_untreated_mean <- 60
treatment_effect <- 10

# SIMULATE DATA ----------------------------------------------------------------

# A df with one row per student. Randomly assign each to a school, and choose
# which schools were treated (even schools).
df <- tibble(student = 1:num_students,
             school = sample(1:num_schools, size = num_students, replace = TRUE),
             treated = school %% 2 == 0)

# Simulate effects specific to each school (separate from the treatment effect)
school_effects <- rnorm(num_schools,
                        mean = 0,
                        sd = stddev_schools)

# As a convenient intermediate quantity, define each student's expected grade: 
# the mean for students at untreated schools +
#  the effect specific to that student's school + 
#  the treatment effect if their school was treated
df$grade_expected <-
  grade_untreated_mean +
  map_dbl(df$school, function(which_school) {school_effects[[which_school]]}) +
  if_else(df$treated, treatment_effect, 0)

# Using that intermediate, simulate each student's grade
df$grade <- rnorm(n = num_students,
                  mean = df$grade_expected,
                  sd = stddev_students)
df$grade <- pmin(df$grade, 100)
df$grade <- pmax(df$grade, 0)

ggplot(df %>%
         mutate(treated = if_else(treated, "treated", "not treated")),
       aes(as.factor(school), grade)) +
  geom_violin() +
  geom_sina(aes(color = treated)) +
  theme_classic() +
  scale_y_continuous(expand = expansion(mult = c(0.02, 0.02))) +
  labs(x = "school",
       y = "grade",
       color = "") +
  scale_color_brewer(palette = "Set1") 
ggsave(file_output_plot_data, height = 6, width = 7)

# FREQUENTIST ESTIMATION -------------------------------------------------------

lmm <- lmer(data = df, grade ~ treated + (1 | school))
summary(lmm)
confint(lmm)

# RUN STAN ---------------------------------------------------------------------

# Collect together all the data Stan wants in a list. Make one list for sampling
# from the posterior and one for sampling from the prior.
list_stan_posterior <- list(
  num_schools = num_schools,
  num_students = num_students,
  school = df$school,
  grade = df$grade,
  treated = df$treated,
  get_posterior_not_prior = 1L
)
list_stan_prior <- list_stan_posterior
list_stan_prior$get_posterior_not_prior <- 0L

# Compile the Stan code
model_compiled <- stan_model(file_input_stan_code)

# Run the Stan code
num_mcmc_iterations <- 500
num_mcmc_chains <- 4
fit <- sampling(model_compiled,
                data = list_stan_posterior,
                iter = num_mcmc_iterations,
                chains = num_mcmc_chains)
fit_prior <- sampling(model_compiled,
                      data = list_stan_prior,
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
  pivot_longer(-c("sample", "density_type"), names_to = "parameter")

# Plot each parameter's marginal posterior, marginal prior and simulation truth 
list_parameters_truth <- list(stddev_students = stddev_students,
     stddev_schools = stddev_schools,
     grade_untreated_mean = grade_untreated_mean, 
     treatment_effect = treatment_effect)
df_parameters_truth <- tibble(parameter = names(list_parameters_truth),
                             value = unlist(list_parameters_truth)) %>%
  bind_rows(tibble(parameter = paste0("school_effects[", 1:num_schools, "]"),
                   value = school_effects))
ggplot(df_fit %>% 
         filter(parameter != "lp__",
                ! str_starts(parameter, "grade_expected"),
                ! str_starts(parameter, "grade_simulated"))) +
  geom_histogram(aes(value, y = ..density.., fill = density_type),
                 alpha = 0.6,
                 position = "identity",
                 bins = 60) +
  geom_vline(data = df_parameters_truth, aes(xintercept = value)) +
  facet_wrap(~parameter, scales = "free", nrow = 3) +
  scale_fill_brewer(palette = "Set1") +
  theme_classic() +
  coord_cartesian(expand = FALSE) +
  labs(fill = "",
       x = "parameter value",
       y = "probability density")
ggsave(file_output_plot_params, height = 6, width = 12)
