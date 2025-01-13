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
m_true <- 1
c_true <- 5
sigma_true <- 2
x_vector <- 1:30

# SIMULATE DATA ----------------------------------------------------------------

set.seed(seed)

num_observations <- length(x_vector)

y_vector <- rnorm(n = num_observations,
                mean = m_true * x_vector + c_true,
                sd = sigma_true)

# PLOT DATA --------------------------------------------------------------------

df_data <- tibble(x = x_vector,
                  y = y_vector)

ggplot(df_data) +
  geom_point(aes(x, y)) +
  theme_classic() 

# DEFINE AND EXPLORE THE LOG LIKELIHOOD  ---------------------------------------

# Two different functions that should give the same ll as a function of the 
# parameters (except differing by a constant that's independent of the 
# parameters, which is irrelevant for our purposes).
ll_1 <- function(m, c, sigma) {
  sum(dnorm(x = y_vector,
            mean =  m * x_vector + c,
            sd = sigma,
            log = TRUE))
}
ll_2 <- function(m, c, sigma) {
  -num_observations * log(sigma) -
    (1 / (2 * sigma^2)) * sum((y_vector - m * x_vector - c)^2)
}

# Define a set of points in parameter space: a 3D lattice (grid) of values to
# consider for m, c, and sigma. cross_df makes all possible combinations of 
# values from the list of vectors supplied as arguments. Inspect the resulting
# df_ll if you're not clear what we've done.
df_ll <- expand_grid(m = seq(from = 0.1, to = 2, by = 0.1),
                     c = seq(from = 0, to = 10, by = 0.5),
                     sigma = seq(from = 0.2, to = 4, by = 0.2))

# Calculate the ll for each point in our parameter space, using both methods 
df_ll <- df_ll %>%
  mutate(ll_1 = pmap_dbl(list(m = m, c = c, sigma = sigma), ll_1),
         ll_2 = pmap_dbl(list(m = m, c = c, sigma = sigma), ll_2),
         diff_1_2 = ll_1 - ll_2)

# Inspect the differences in the answers given by the two methods - it's 
# always the same (i.e. independent of the parameters) to within a very small
# value (numerical imperfection) that's not worrisome.
max(df_ll$diff_1_2) - min(df_ll$diff_1_2)

# Keep the col for only one of the methods. Rename it.
df_ll <- df_ll %>%
  select(-c("ll_2", "diff_1_2")) %>%
  rename(ll = ll_1)

# Find the ML estimate of m, c and sigma among the values we've considered
df_ll_ml <- df_ll %>%
  filter(ll == max(ll))
m_ml <- df_ll_ml$m
c_ml <- df_ll_ml$c
sigma_ml <- df_ll_ml$sigma

# Fixing each of the three parameters in turn at their ML estimate, plot how the
# ll varies as a function of the other two. We'll use coloured contours that
# divide the data into equal sized subsets, rather than the norm of equally 
# spaced contours, because some parts of parameter space have dramatically worse
# likelihoods than others. Alternatively you could zoom in to the area of 
# parameter space closest to the likelihood's maximum.
df_ll_fixed_m <- df_ll %>%
  filter(m == m_ml)
ll_quantiles_fixed_m <- quantile(df_ll_fixed_m$ll,
                                 seq(from = 0, to = 1, by = 0.05))
ggplot(df_ll_fixed_m) +
  geom_contour_filled(aes(x = c,
                y = sigma,
                z = ll),
                breaks = ll_quantiles_fixed_m) +
  theme_classic() +
  coord_cartesian(expand = FALSE) +
  labs(fill = "log likelihood")
df_ll_fixed_c <- df_ll %>%
  filter(c == c_ml)
ll_quantiles_fixed_c <- quantile(df_ll_fixed_c$ll, seq(0, 1, 0.05))
ggplot(df_ll_fixed_c) +
  geom_contour_filled(aes(x = m,
                          y = sigma,
                          z = ll),
                      breaks = ll_quantiles_fixed_c) +
  theme_classic() +
  coord_cartesian(expand = FALSE) +
  labs(fill = "log likelihood")
df_ll_fixed_sigma <- df_ll %>%
  filter(sigma == sigma_ml)
ll_quantiles_fixed_sigma <- quantile(df_ll_fixed_sigma$ll, seq(0, 1, 0.05))
ggplot(df_ll_fixed_sigma) +
  geom_contour_filled(aes(x = m,
                          y = c,
                          z = ll),
                      breaks = ll_quantiles_fixed_sigma) +
  theme_classic() +
  coord_cartesian(expand = FALSE) +
  labs(fill = "log likelihood")

# Find the ML estimate of m, c and sigma by numerical optimisation. We need a
# a function that takes all the parameters to be optimised together as a single
# list.
ll <- function(parameter_vector) {
  stopifnot(length(parameter_vector) == 3)
  m <- parameter_vector[[1]]
  c <- parameter_vector[[2]]
  sigma <- parameter_vector[[3]]
  -num_observations * log(sigma) -
    (1 / (2 * sigma^2)) *
    sum((y_vector - m * x_vector - c)^2)
}
optim(par = c(0, 0, 1),
      fn = ll, 
      control = list(fnscale = -1), # tells optim to maximise, not minimise
      method = "L-BFGS-B", # a method that accepts lower and/or upper boundaries
      lower = c(-Inf, -Inf, 0)) # sigma cannot be negative

# An alternative way of doing this analysis, which is convenient but hides the 
# detail of the likelihood, hindering your understanding of what you're doing 
model_fit <- lm(data = df_data, 
    formula = y ~ x)
summary(model_fit)

# Repeat the above steps for different values of num_observations and see how
# the estimates become more accurate, and the likelihood becomes more sharply
# peaked, with increasing data.