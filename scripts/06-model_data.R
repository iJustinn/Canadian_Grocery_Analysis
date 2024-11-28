#### Preamble ####
# Purpose: To build and save a Bayesian regression model that predicts the current price of beef based on month, old price, and vendor, using the `rstanarm` package with specified priors and a Gaussian family.
# Author: Ziheng Zhong
# Date: 20 November 2024
# Contact: ziheng.zhong@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
  # - Package must be installed
  # - 03-clean_data.R must have been run



#### Workspace setup ####
# load library
library(tidyverse)
library(rstanarm)
library(arrow)
library(here)

# laod data
beef_data <- read_parquet(here("data", "02-analysis_data", "beef_data.parquet"))



#### Model data ####
beef_model <-
  stan_glm(
    formula = current_price ~ month + old_price + vendor,
    data = beef_data,
    family = gaussian(),
    prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_aux = exponential(rate = 1, autoscale = TRUE),
    seed = 304
  )



#### Save model ####
saveRDS(
  beef_model,
  file = here("models", "beef_model.rds")
)


