#### Preamble ####
# Purpose: Simulates a dataset of Australian electoral divisions, including the 
  #state and party that won each division.
# Author: Rohan Alexander
# Date: 26 September 2024
# Contact: rohan.alexander@utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed
# Any other information needed? Make sure you are in the `starter_folder` rproj



#### Workspace setup ####
library(tidyverse)
set.seed(304)



#### Simulate data ####
# rows of simulated data
n <- 100

# simulation
simulated_data <- tibble(
  vendor = sample(c("Walmart", "TandT"), n, replace = TRUE),
  product_id = sample(1000:9999, n, replace = TRUE),
  product_name = sample(c("beef steak", "beef ribs", "beef brisket", "beef shank"), n, replace = TRUE),
  brand = sample(c("BrandA", "BrandB", "BrandC", "BrandD"), n, replace = TRUE),
  current_price = round(runif(n, 5, 50), 2),
  old_price = ifelse(runif(n) > 0.3, round(runif(n, 5, 50), 2), NA),
  units = sample(1:10, n, replace = TRUE),
  price_per_unit = current_price / units,
  year = sample(2021:2023, n, replace = TRUE),
  month = sample(1:12, n, replace = TRUE),
  day = sample(1:28, n, replace = TRUE)
)

# replace NA values in old_price with current_price
simulated_data <- simulated_data %>%
  mutate(old_price = ifelse(is.na(old_price), current_price, old_price))



#### Save data ####
write_csv(simulated_data, "data/00-simulated_data/simulate_beef_data.csv")
