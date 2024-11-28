#### Preamble ####
# Purpose: Models and visualizes beef price trends from a dataset.
# Author: Ziheng Zhong
# Date: 22 November 2024
# Contact: ziheng.zhong@example.com
# License: MIT
# Pre-requisites: Ensure the 'beef_data.csv' file is available in the appropriate directory.
# Any other information needed? This script creates three different visualizations for analysis.



#### Workspace setup ####
# load library
library(tidyverse)
library(bayesplot)
library(arrow)
library(here)

# load data
beef_data <- read_parquet(here("data", "02-analysis_data", "beef_data.parquet"))

# load model
beef_model <- readRDS (file = here:: here ("models/beef_model.rds"))



#### Chart 1 ####
# Distribution of Current Price
ggplot(beef_data, aes(x = current_price)) +
  geom_histogram(binwidth = 1, fill = "lightgrey", color = "darkgrey", alpha = 0.7) +
  geom_density(aes(y = ..count..), color = "red", size = 1) +
  labs(title = "Distribution of Current Prices", x = "Current Price (in $)", y = "Frequency") +
  theme_minimal()



#### Chart 2 ####
# Price Difference
beef_data <- beef_data %>%
  mutate(price_difference = old_price - current_price)

ggplot(beef_data, aes(x = vendor, y = price_difference)) +
  geom_boxplot(fill = "lightgrey", color = "darkgrey", alpha = 0.7) +
  labs(title = "Price Difference by Vendor", x = "Vendor", y = "Price Difference (in $)") +
  theme_minimal()



#### Chart 3 ####
# Average Current Price Over Time
beef_data <- beef_data %>%
  mutate(date = as.Date(paste(year, month, day, sep = "-"), format = "%Y-%m-%d"))

avg_price_per_date <- beef_data %>%
  group_by(date) %>%
  summarise(avg_current_price = mean(current_price, na.rm = TRUE))

ggplot(avg_price_per_date, aes(x = date, y = avg_current_price)) +
  geom_line(color = "darkgrey", size = 1) +
  labs(title = "Average Current Price Over Time", x = "Date", y = "Average Current Price (in $)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))



#### Chart 4 ####
# Distribution of Current vs. Old Price
ggplot(beef_data, aes(x = old_price, y = current_price)) +
  geom_point(color = 'lightgrey', alpha = 0.7) +
  geom_smooth(method = 'loess', color = 'darkgrey', fill = 'red', alpha = 0.8, se = TRUE) +
  labs(title = "Distribution of Current vs. Old Price of Beef", x = "Old Price (in $)", y = "Current Price (in $)") +
  theme_minimal()



#### Chart 5 ####
# Unit Price Distribution
ggplot(beef_data, aes(x = price_per_unit)) +
  geom_histogram(binwidth = 0.1, fill = "lightgrey", color = "darkgrey", alpha = 0.7) +
  geom_density(aes(y = after_stat(count)), color = "red", linewidth = 1) +
  labs(title = "Distribution of Unit Prices", x = "Unit Price ($ per 100 grams)", y = "Frequency") +
  theme_minimal()



#### Model 1 ####
# Visual summary
pp_check(beef_model) +
  ggtitle("Posterior Predictive Check for Beef Model")



#### Model 2 ####
# Text summary
summary(beef_model)


