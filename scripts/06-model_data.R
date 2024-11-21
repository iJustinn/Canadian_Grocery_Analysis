#### Preamble ####
# Purpose: Models... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]



#### Workspace setup ####
# load library
library(tidyverse)
library(rstanarm)
library(here)

# laod data
beef_data <- read_csv(here("data", "02-analysis_data", "beef_data.csv"))



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


