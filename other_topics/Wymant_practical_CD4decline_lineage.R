# PRELIMINARIES ----------------------------------------------------------------

# Author: Chris Wymant

# Acknowledgment: I wrote this while funded by ERC Advanced Grant PBDR-339251
# and a Li Ka Shing Foundation grant, both awarded to Christophe Fraser.

# Abbreviations:
# df = dataframe
# cat = category
# ref = reference (the reference cat)
# pat = patient
# lin = lineage
# sd = standard deviation
# inter = intercept
# param = parameter
# num = number

# Model description:
# We model cd4 values observed at different times (since diagnosis) for 
# different individuals with different characteristics, via 
# cd4 ~ N(inter + time * slope, error sd)
# inter and slope vary between individuals, by fixed effects for age and sex 
# and lin, and by what would be called random effects in frequentist statistics
# for the specific individual in question, i.e. we model a per-individual 
# effect that comes from a normal distribution whose sd we estimate. All the 
# effects interact additively to determine the overall inter and slope for each
# individual.

library(tidyverse)
library(rstan)
library(assertr)
options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)
theme_set(theme_classic())

# WARNING: deletes all objects in your R session's memory
rm(list = ls()) 

# INPUT ------------------------------------------------------------------------

# Change directory appropriately:
setwd("~/Dropbox (Infectious Disease)/talks_mine_misc/2023-01_StatsLectureAndPractical/Canvas/")

file_in_individuals <- "ATHENA_clinical_data/individual_summary.csv"

file_in_cd4 <- "ATHENA_clinical_data/cd4_counts_pretreatment.csv"

file_in_stan_model <- "CD4decline_lineage.stan"

# Set this to a finite value to discard most of the non-lineage data (for speed
# while testing)
num_rows_to_keep <- Inf

# 200 iterations takes about 40 minutes on my laptop with 4-threading. It's not
# enough for proper convergence but ends up close to the right answer.
num_mcmc_iterations <- 200 
num_mcmc_chains <- 4 

ref_sex <- "male"
ref_age <- "[30, 40)"
ref_lin <- "not.lineage"

# PREPARE DATA -----------------------------------------------------------------

check_df_no_NAs <- function(df) {
  stopifnot(all(complete.cases(df)))
  invisible(df)
}

# Read in the input csvs. 
# "individual" characteristics (one row per individual):
df_ind <- read_csv(file_in_individuals, col_types = cols_only(
  id_paper = col_factor(),
  in_lineage = col_factor(),
  sex = col_factor(),
  age_diagnosed = col_factor()
)) %>%
  rename(lin = in_lineage,
         age = age_diagnosed)
# And CD4 counts (many per individual):
df_cd4_decline <- read_csv(file_in_cd4, col_types = cols(
  id_paper = col_factor()
))

# Merge individual-level data into the CD4 counts.
stopifnot(all(df_cd4_decline$id_paper %in% df_ind$id_paper))
stopifnot(! anyNA(df_ind$lin))
df_cd4_decline <- left_join(df_cd4_decline, df_ind, by = "id_paper") 

# Define the ref cat
df_cd4_decline <- df_cd4_decline %>%
  mutate(sex = relevel(sex, ref = ref_sex),
         age = relevel(age, ref_age),
         lin = relevel(df_cd4_decline$lin, ref = ref_lin))

# Drop all observations where any of the variables is missing
df_cd4_decline <- df_cd4_decline %>%
  drop_na()

# Otionally, discard most of the non-lineage data for speed while testing
df_cd4_decline_orig <- df_cd4_decline
df_cd4_decline <- df_cd4_decline %>%
  arrange(desc(lin)) %>%
  filter(row_number() <= num_rows_to_keep)

# Create design matrices, i.e. encoding the values of predictor variables for
# each individual. We'll estimate the associated regression coefficients, one
# per column of the matrix.
design_matrix_inter <- model.matrix(data = df_cd4_decline,
                                    ~ lin + sex + age)[,-1]
design_matrix_slope <- model.matrix(data = df_cd4_decline,
                                    ~ lin + sex)[,-1]

df_cd4_decline <- df_cd4_decline %>%
  mutate(id_paper = id_paper %>% droplevels() %>% as.integer())
list_cd4_decline <- list(
  num_data = nrow(df_cd4_decline),
  num_predictors_for_inter = ncol(design_matrix_inter),
  num_predictors_for_slope = ncol(design_matrix_slope),
  num_pats = n_distinct(df_cd4_decline$id_paper),
  cd4 = df_cd4_decline$cd4_count,
  time = df_cd4_decline$years_since_diagnosis,
  design_matrix_for_inter = design_matrix_inter,
  design_matrix_for_slope = design_matrix_slope,
  pat = df_cd4_decline$id_paper,
  min_of_prior_for_slope_ref = -150,
  max_of_prior_for_slope_ref = 0,
  min_of_prior_for_inter_ref = 400,
  max_of_prior_for_inter_ref = 700,
  min_of_prior_for_beta_inter = -150,
  max_of_prior_for_beta_inter = 150,
  min_of_prior_for_beta_slope = -100,
  max_of_prior_for_beta_slope = 100,
  min_of_prior_for_sd_error = 10,
  max_of_prior_for_sd_error = 500,
  min_of_prior_for_slope_pat_scale = 1,
  max_of_prior_for_slope_pat_scale = 100,
  min_of_prior_for_inter_pat_scale = 1,
  max_of_prior_for_inter_pat_scale = 500,
  calculate_likelihood = 1L
)

list_cd4_decline_prior <- list_cd4_decline
list_cd4_decline_prior$calculate_likelihood <- 0L

# RUN STAN ---------------------------------------------------------------------

# Compile the stan code.
model_compiled <- rstan::stan_model(file_in_stan_model)

# Run Stan
time_1 <- Sys.time()
fit <- sampling(model_compiled,
                data = list_cd4_decline,
                iter = num_mcmc_iterations,
                chains = num_mcmc_chains)
time_2 <- Sys.time()
cat("Posterior: ")
difftime(time_2, time_1)
fit_prior <- sampling(model_compiled,
                      data = list_cd4_decline_prior,
                      iter = num_mcmc_iterations,
                      chains = num_mcmc_chains)
time_3 <- Sys.time()
cat("Prior: ")
difftime(time_3, time_2)

# ANALYSE STAN OUTPUT ----------------------------------------------------------

# Merge prior and posterior results into a single df
df_fit <- bind_rows(fit %>%
                      as.data.frame() %>% 
                      mutate(density_type = "posterior",
                             sample = row_number()),
                    fit_prior %>% 
                      as.data.frame() %>%
                      mutate(density_type = "prior",
                             sample = row_number())) %>%
  select(!starts_with("inter_and_slope_per_pat_unscaled[") &
           !starts_with("cd4_expected") &
           !starts_with("cd4_simulated") &
           !starts_with("Rho", ignore.case = FALSE) &
           !starts_with("lp__")) %>%
  as_tibble()

# Lengthen the results: go from one col per parameter to a single col that says
# which parameter the value in the next col refers to. In this form we can then
# conveniently derive things from parameter names, namely which level of 
# factor-valued parameters we're talking about.
df_fit_long <- df_fit %>% 
  pivot_longer(-c("sample", "density_type"), names_to = "param") %>%
  mutate(beta_inter_level = str_match(param, "^beta_inter\\[([0-9]+)\\]")[,2] %>%
           as.integer(),
         beta_slope_level = str_match(param, "^beta_slope\\[([0-9]+)\\]")[,2] %>%
           as.integer(),
         beta_inter_name = map_chr(beta_inter_level, function(level) {
           if (is.na(level)) return(NA_character_)
           paste0("beta_inter_", colnames(design_matrix_inter)[[level]])
         }),
         beta_slope_name = map_chr(beta_slope_level, function(level) {
           if (is.na(level)) return(NA_character_)
           paste0("beta_slope_", colnames(design_matrix_slope)[[level]])
         })) %>%
  mutate(param = if_else(!is.na(beta_inter_name), beta_inter_name,
                         if_else(!is.na(beta_slope_name), beta_slope_name,
                                 param))) %>%
  select(density_type, sample, param, value)

# Widen results again, now the params have interpretable names
df_fit <- df_fit_long %>%
  pivot_wider(names_from = param, values_from = value)

# Plot priors and posteriors for param values
ggplot(df_fit_long %>%
         filter(!endsWith(param, "NA"))) +
  geom_histogram(aes(value, fill = density_type),
                 alpha = 0.6, 
                 position = "identity",
                 bins = 50) +
  facet_wrap(~param, scales = "free", nrow = 3) +
  theme_classic() +
  scale_fill_brewer(palette = "Set1") +
  labs(fill = "") +
  coord_cartesian(expand = F, ylim = c(0, NA))

# Make a new df that expands each existing row into one row for each possible
# combination of factor values age & sex & lin (referring to each combination as
# a 'group')...
all_cats_all_densities_all_samples <- cross_df(
  list(cat_sex = unique(df_cd4_decline$sex),
       cat_age = unique(df_cd4_decline$age),
       cat_lin = unique(df_cd4_decline$lin),
       density_type = c("posterior", "prior"),
       sample = unique(df_fit$sample)))
df_fit_groups <- right_join(df_fit, 
                            all_cats_all_densities_all_samples,
                            by = c("density_type", "sample")) %>%
  check_df_no_NAs()

# ...then in that df, calculate the value of inter and slope for that MCMC sample
# and that group...
df_fit_groups$inter_cat <- NA_real_
df_fit_groups$slope_cat <- NA_real_
for (i in 1:nrow(df_fit_groups)) {
  cat_sex <- df_fit_groups$cat_sex[[i]]
  cat_age <- df_fit_groups$cat_age[[i]]
  cat_lin <- df_fit_groups$cat_lin[[i]]
  inter_cat <- df_fit_groups$inter_ref[[i]]
  slope_cat <- df_fit_groups$slope_ref[[i]]
  if (cat_sex != ref_sex) {
    inter_cat <- inter_cat + df_fit_groups[[paste0("beta_inter_sex", cat_sex)]][[i]]
    slope_cat <- slope_cat + df_fit_groups[[paste0("beta_slope_sex", cat_sex)]][[i]]
  }
  if (cat_age != ref_age) {
    inter_cat <- inter_cat + df_fit_groups[[paste0("beta_inter_age", cat_age)]][[i]]
  }
  if (cat_lin != ref_lin) {
    inter_cat <- inter_cat + df_fit_groups[[paste0("beta_inter_lin", cat_lin)]][[i]]
    slope_cat <- slope_cat + df_fit_groups[[paste0("beta_slope_lin", cat_lin)]][[i]]
  }
  df_fit_groups$inter_cat[[i]] <- inter_cat
  df_fit_groups$slope_cat[[i]] <- slope_cat
}

# ...now make copies of every row, with different values of time 
df_fit_groups <- bind_rows(df_fit_groups %>% mutate(time = 0),
                           df_fit_groups %>% mutate(time = 1),
                           df_fit_groups %>% mutate(time = 2),
                           df_fit_groups %>% mutate(time = 3),
                           df_fit_groups %>% mutate(time = 4),
                           df_fit_groups %>% mutate(time = 5),
                           df_fit_groups %>% mutate(time = 6),
                           df_fit_groups %>% mutate(time = 7),
                           df_fit_groups %>% mutate(time = 8),
                           df_fit_groups %>% mutate(time = 9),
                           df_fit_groups %>% mutate(time = 10))

# Finally we can use that df to plot the expected CD4 over time for each group
ggplot(df_fit_groups %>%
         mutate(density_type = factor(density_type, levels = c("prior", "posterior")),
                cat_age = factor(cat_age, levels = c("[0, 30)", "[30, 40)", "[40, 50)", "[50, 60)", "60+")),
                cat_lin = factor(cat_lin, levels = c("in.lineage", "not.lineage")))) +
  geom_line(aes(x = time, 
                y = inter_cat + slope_cat * time, 
                group = paste(sample, cat_lin),
                col = cat_lin),
            alpha = 0.2) +
  #linetype = )) +
  facet_grid(vars(cat_age), vars(cat_sex, density_type)) +
  coord_cartesian(ylim = c(200,650),
                  xlim = c(0, 7.5),
                  expand = F) +
  scale_color_brewer(palette = "Set1") +
  geom_hline(yintercept = 350, col = "black", linetype = "dashed") +
  labs(x = "years since diagnosis",
       y = "Expected CD4 count",
       col = "") +
  guides(color = guide_legend(override.aes = list(alpha = 1)))

# CALCULATE FREQUENTIST CIs AND COMPARE TO THE POSTERIOR -----------------------

library(lme4)

# Get maximum-likehood results
lmm <- lmer(data = df_cd4_decline, 
            # Model CD4 counts as a linear function of time,
            cd4_count ~ years_since_diagnosis +  
              # with a fixed effect of age on the intercept,
              age + 
              # a fixed effect of sex on both intercept and slope,
              years_since_diagnosis * sex + 
              # a fixed effect of the lineage on both intercept and slope,
              years_since_diagnosis * lin + 
              # and a random effect of the individual on both intercept and slope.
              (years_since_diagnosis | id_paper))  

# Estimate the CIs; takes a few minutes
confints <- confint(lmm)

# Wrangle data
df_frequentist <- inner_join(
  summary(lmm)$coefficients %>% as_tibble(rownames = "param"),
  confints %>% as_tibble(rownames = "param"),
  by = "param")
df_frequentist[df_frequentist$param == "(Intercept)", ]$param <- "inter_ref"
df_frequentist[df_frequentist$param == "years_since_diagnosis", ]$param <- "slope_ref"
df_frequentist[df_frequentist$param == "age[40, 50)", ]$param <- "beta_inter_age[40, 50)"
df_frequentist[df_frequentist$param == "age[0, 30)", ]$param <- "beta_inter_age[0, 30)"
df_frequentist[df_frequentist$param == "age[50, 60)", ]$param <- "beta_inter_age[50, 60)"
df_frequentist[df_frequentist$param == "age60+", ]$param <- "beta_inter_age60+"
df_frequentist[df_frequentist$param == "sexfemale", ]$param <- "beta_inter_sexfemale"
df_frequentist[df_frequentist$param == "linin.lineage", ]$param <- "beta_inter_linin.lineage"
df_frequentist[df_frequentist$param == "years_since_diagnosis:sexfemale", ]$param <- "beta_slope_sexfemale"
df_frequentist[df_frequentist$param == "years_since_diagnosis:linin.lineage", ]$param <- "beta_slope_linin.lineage"
df_confints <- confints %>% as_tibble(rownames = "param")
df_frequentist <- df_frequentist %>%
  bind_rows(list(param = "inter_pat_scale",
                 Estimate = 256.85,
                 `2.5 %` = df_confints[df_confints$param == ".sig01",]$`2.5 %`,
                 `97.5 %` = df_confints[df_confints$param == ".sig01",]$`97.5 %`),
            list(param = "sd_error",
                 Estimate = 111.40,
                 `2.5 %` = df_confints[df_confints$param == ".sigma",]$`2.5 %`,
                 `97.5 %` = df_confints[df_confints$param == ".sigma",]$`97.5 %`),
            list(param = "slope_pat_scale",
                 Estimate = 58.89,
                 `2.5 %` = df_confints[df_confints$param == ".sig03",]$`2.5 %`,
                 `97.5 %` = df_confints[df_confints$param == ".sig03",]$`97.5 %`),
            list(param = "rho",
                 Estimate = -0.57,
                 `2.5 %` = df_confints[df_confints$param == ".sig02",]$`2.5 %`,
                 `97.5 %` = df_confints[df_confints$param == ".sig02",]$`97.5 %`))

# Plot prior, posterior and Frequentist CIs 
ggplot(df_fit_long %>%
         filter(!endsWith(param, "NA"))) +
  geom_histogram(aes(value, fill = density_type),
                 alpha = 0.6, 
                 position = "identity",
                 bins = 50) +
  geom_vline(data = df_frequentist %>%
               filter(!endsWith(param, "NA")),
             aes(xintercept = `2.5 %`),  color = "black", linetype = "dashed") +
  geom_vline(data = df_frequentist %>%
               filter(!endsWith(param, "NA")),
             aes(xintercept = `97.5 %`), color = "black", linetype = "dashed") +
  geom_vline(data = df_frequentist %>%
               filter(!endsWith(param, "NA")),
             aes(xintercept = Estimate), color = "black", linetype = "solid") +
  facet_wrap(~param, scales = "free", nrow = 3) +
  theme_classic() +
  scale_fill_brewer(palette = "Set1") +
  labs(fill = "") +
  coord_cartesian(expand = F, ylim = c(0, NA))
