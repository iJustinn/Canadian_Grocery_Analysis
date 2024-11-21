#### Preamble ####
# Purpose: Tests the structure and validity of the simulated Australian 
  #electoral divisions dataset.
# Author: Rohan Alexander
# Date: 26 September 2024
# Contact: rohan.alexander@utoronto.ca
# License: MIT
# Pre-requisites: 
  # - The `tidyverse` package must be installed and loaded
  # - 00-simulate_data.R must have been run



#### Workspace setup ####
# load library
library(tidyverse)
library(testthat)
library(here)

# Define file path
file_path <- here("data", "00-simulated_data", "simulate_soy_data.csv")

# Check if file exists before running tests
if (!file.exists(file_path)) {
  stop("The file 'simulate_soy_data.csv' does not exist. Ensure 00-simulate_data.R has been run to generate the file.")
}



#### Test data ####
# test if the data was successfully loaded
test_that("Dataset loading", {
  simulate_data <- read_csv(file_path)
  expect_true(exists("simulate_data"), label = "The dataset should be successfully loaded.")
})

# Check for missing values in each column
test_that("Missing values check", {
  simulate_data <- read_csv(file_path)
  missing_values <- colSums(is.na(simulate_data))
  expect_true(is.numeric(missing_values), label = "Missing values should be calculated correctly.")
})

# Ensure there are no negative values in price columns
test_that("No negative values in price columns", {
  simulate_data <- read_csv(file_path)
  expect_false(any(simulate_data$current_price < 0), label = "current_price should not contain negative values.")
  expect_false(any(simulate_data$old_price < 0), label = "old_price should not contain negative values.")
})

# Check unique values in categorical columns
test_that("Unique values in categorical columns", {
  simulate_data <- read_csv(file_path)
  unique_vendors <- unique(simulate_data$vendor)
  expect_true(length(unique_vendors) > 0, label = "Vendor column should have unique values.")
  
  unique_products <- unique(simulate_data$product_name)
  expect_true(length(unique_products) > 0, label = "Product name column should have unique values.")
  
  unique_brands <- unique(simulate_data$brand)
  expect_true(length(unique_brands) > 0, label = "Brand column should have unique values.")
})

# Check that `vendor` column contains only allowed values
test_that("Vendor column allowed values", {
  simulate_data <- read_csv(file_path)
  allowed_vendors <- c("Walmart", "TandT")
  expect_true(all(simulate_data$vendor %in% allowed_vendors), label = "Vendor column should contain only allowed values.")
})

# Check that `product_name` contains "beef"
test_that("Product name contains beef", {
  simulate_data <- read_csv(file_path)
  expect_true(all(str_detect(tolower(simulate_data$product_name), "beef")), label = "All product names should contain 'beef'.")
})

# Check that `year`, `month`, and `day` columns contain valid values
test_that("Date columns validation", {
  simulate_data <- read_csv(file_path)
  expect_true(all(simulate_data$year >= 2021 & simulate_data$year <= 2023), label = "Year column should contain values between 2021 and 2023.")
  expect_true(all(simulate_data$month >= 1 & simulate_data$month <= 12), label = "Month column should contain values between 1 and 12.")
  expect_true(all(simulate_data$day >= 1 & simulate_data$day <= 28), label = "Day column should contain values between 1 and 28.")
})

# Check that `price_per_unit` is correctly calculated
test_that("Price per unit calculation", {
  simulate_data <- read_csv(file_path)
  expect_equal(simulate_data$price_per_unit, simulate_data$current_price / simulate_data$units, label = "Price per unit should be correctly calculated as current_price divided by units.")
})


