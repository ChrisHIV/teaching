# LIBRARIES --------------------------------------------------------------------

library(tidyverse)

# PRELIMINARY REMARKS ----------------------------------------------------------

# The code here is written using the tidyverse, which has the benefit of being
# more human-readable than functions from 'base R' (i.e. included in the 
# language by default without loading extra packages.) If you don't understand
# it there's a quick introduction here
# https://github.com/ChrisHIV/teaching/blob/main/other_topics/tidyverse_quick_intro.md
# and in many other places on the internet.

# ABBREVIATIONS ----------------------------------------------------------------

# df = dataframe
# col = column
# num = number (of)
# ll = log likelihood
# ML = ml = maximum-likelihood
# diff = difference

# CHOOSE INPUT PARAMETERS FOR SIMULATION ---------------------------------------

seed <- 12345 # seed for random number generation, to allow reproducibility
lambda_true <- 2.5 # rate parameter
num_observations <- 20

# SIMULATE DATA ----------------------------------------------------------------

set.seed(seed)

counts <- rpois(n = num_observations,
                lambda = lambda_true)

# PLOT DATA --------------------------------------------------------------------

df_data <- tibble(x = counts)

ggplot(df_data) +
  geom_histogram(aes(x),
                 breaks = seq(-0.5, max(counts) + 0.5, by = 1)) +
  theme_classic() +
  coord_cartesian(expand = FALSE) +
  labs(x = "count",
       y = "number of times that count was observed")

# DEFINE AND EXPLORE THE LOG LIKELIHOOD  ---------------------------------------

# Three different functions that should give the same ll as a function of lambda
# (except differing by a constant that's independent of lambda, which is
# irrelevant for our purposes).
ll_1 <- function(lambda_) {
  sum(log(dpois(x = counts,
        lambda = lambda_)))
}
ll_2 <- function(lambda_) {
  sum(dpois(x = counts,
            lambda = lambda_,
            log = TRUE))
}
ll_3 <- function(lambda_) {
  sum(counts) * log(lambda_) - num_observations * lambda_
}

# Pick a series of values for lambda and calculate the ll for each value, using
# each of the three methods 
df_ll <- tibble(lambda = seq(from = 0.1,
                                     to = 5,
                                     by = 0.1),
                        ll_1 = map_dbl(lambda, ll_1),
                ll_2 = map_dbl(lambda, ll_2),
                ll_3 = map_dbl(lambda, ll_3),
                diff_1_2 = ll_1 - ll_2,
                diff_1_3 = ll_1 - ll_3)

# Inspect the differences in the answers given by the three methods - it's 
# always the same (i.e. independent of lambda) to within machine precision.
table(df_ll$diff_1_2)
table(df_ll$diff_1_3)

# Keep the col for only one of the methods. Rename it. Exponentiate it.
df_ll <- df_ll %>%
  select(lambda, ll_1) %>%
  rename(ll = ll_1) %>%
  mutate(likelihood = exp(ll))

# 'Pivot' the df from 'wide' format (many cols, few rows) to 'long' format (many
# rows, few cols). As a rule of thumb, you'll find it easier to plot dfs using
# ggplot if they're relatively long rather than wide. Here it's just so that we
# get one row with the value of the likelihood and another row with the value of
# the ll, both with the same lambda. 
df_ll_long <- df_ll %>%
  pivot_longer(c("ll", "likelihood"), names_to = "which_quantity")

# Plot both the likelihood and the ll
ggplot(df_ll_long) +
  geom_line(aes(x = lambda,
                y = value)) +
  facet_wrap(~which_quantity, scales = "free_y") +
  theme_classic() +
  coord_cartesian(expand = FALSE)

# Find the ML estimate of lambda among the values we've considered
df_ll %>%
  filter(ll == max(ll))

# Find the ML estimate of lambda by numerically optimising the ll_3 function
optim(par = 1, # starting guess for lambda
      fn = ll_3, 
      control = list(fnscale = -1), # tells optim to maximise, not minimise
      method = "L-BFGS-B", # a method that accepts lower and/or upper boundaries
      lower = 0, # lambda cannot be negative
      upper = Inf)

# An alternative way of doing this analysis, which is convenient but hides the 
# detail of the likelihood, hindering your understanding of what you're doing 
model_fit <- glm(data = tibble(observation = counts), 
    family = poisson(link = "log"),
    formula = observation ~ 1)
exp(coefficients(model_fit)) # the ML estimate of lambda

# Repeat the above steps for different values of num_observations and see how
# the estimates become more accurate, and the likelihood becomes more sharply
# peaked, with increasing data.

# Extension:
# The formula argument used for the glm function, observation ~ 1, means we
# modelled the rate parameter in the poission distribution as being proportional 
# to a constant; the 'regression coefficient' here is the coefficient of that
# constant (1). Remember that in simple linear regression we can use a mean 
# parameter for the normal distribution that's not just a constant c but also 
# varies with x, i.e. y is normally distributed N(mx + c, sigma^2), and we
# estimate the regression coefficient m. In 'Poisson regression' we can do
# something similar - instead of having the mean parameter be proportional to a
# constant, we can allow it to vary with some predictor variable x and see how
# much (if at all) variation in x is associated with variation in the outcome.
# We could do that by using
# formula = observation ~ x
# (the intercept '1' term is included with other predictors by default) or
# adjusting our manually defined likelihood. See more about Poisson regression
# here https://en.wikipedia.org/wiki/Poisson_regression

