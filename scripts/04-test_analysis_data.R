#### Preamble ####
# Purpose: To validate the integrity of the cleaned beef dataset by testing for successful data loading, logical consistency of column values, adherence to specified constraints, and correct calculations for derived metrics.
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
library(testthat)
library(here)

# Define file path
file_path <- here("data", "02-analysis_data", "beef_data.csv")

# Check if file exists before running tests
if (!file.exists(file_path)) {
  stop("The file 'soy_data.csv' does not exist. Ensure the dataset is available.")
}



#### Test data ####
# test if the data was successfully loaded
test_that("Dataset loading", {
  soy_data <- read_csv(file_path)
  expect_true(exists("soy_data"), label = "The dataset should be successfully loaded.")
})

# Check for missing values in each column
test_that("Missing values check", {
  soy_data <- read_csv(file_path)
  missing_values <- colSums(is.na(soy_data))
  expect_true(is.numeric(missing_values), label = "Missing values should be calculated correctly.")
})

# Ensure there are no negative values in price columns
test_that("No negative values in price columns", {
  soy_data <- read_csv(file_path)
  expect_false(any(soy_data$current_price < 0), label = "current_price should not contain negative values.")
  expect_false(any(soy_data$old_price < 0), label = "old_price should not contain negative values.")
})

# Check unique values in categorical columns
test_that("Unique values in categorical columns", {
  soy_data <- read_csv(file_path)
  unique_vendors <- unique(soy_data$vendor)
  expect_true(length(unique_vendors) > 0, label = "Vendor column should have unique values.")
  
  unique_products <- unique(soy_data$product_name)
  expect_true(length(unique_products) > 0, label = "Product name column should have unique values.")
  
  if("brand" %in% colnames(soy_data)) {
    unique_brands <- unique(soy_data$brand)
    expect_true(length(unique_brands) > 0, label = "Brand column should have unique values.")
  }
})

# Check that `vendor` column contains only allowed values
test_that("Vendor column allowed values", {
  soy_data <- read_csv(file_path)
  allowed_vendors <- c("TandT", "Walmart")
  expect_true(all(soy_data$vendor %in% allowed_vendors), label = "Vendor column should contain only allowed values.")
})

# Check that `product_name` contains "soy" or "sauce"
test_that("Product name contains soy or sauce", {
  soy_data <- read_csv(file_path)
  expect_true(any(str_detect(tolower(soy_data$product_name), "beef")), label = "At least one product name should contain 'beef'.")
})

# Check that `year`, `month`, and `day` columns contain valid values
test_that("Date columns validation", {
  soy_data <- read_csv(file_path)
  if("year" %in% colnames(soy_data)) {
    expect_true(all(soy_data$year >= 2021 & soy_data$year <= 2024), label = "Year column should contain values between 2021 and 2024.")
  }
  if("month" %in% colnames(soy_data)) {
    expect_true(all(soy_data$month >= 1 & soy_data$month <= 12), label = "Month column should contain values between 1 and 12.")
  }
  if("day" %in% colnames(soy_data)) {
    expect_true(all(soy_data$day >= 1 & soy_data$day <= 31), label = "Day column should contain values between 1 and 31.")
  }
})

# Check that `price_per_unit` is correctly calculated
test_that("Price per unit calculation", {
  soy_data <- read_csv(file_path)
  if("price_per_unit" %in% colnames(soy_data) & "units" %in% colnames(soy_data)) {
    expect_equal(soy_data$price_per_unit, soy_data$current_price / soy_data$units, label = "Price per unit should be correctly calculated as current_price divided by units.")
  }
})

# Check that `old_price` is not less than `current_price`
test_that("old_price greater than or equal to current_price", {
  soy_data <- read_csv(file_path)
  if("old_price" %in% colnames(soy_data) & "current_price" %in% colnames(soy_data)) {
    expect_true(all(soy_data$old_price >= soy_data$current_price), label = "old_price should be greater than or equal to current_price.")
  }
})


