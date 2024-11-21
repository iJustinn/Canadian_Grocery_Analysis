#### Preamble ####
# Purpose: Cleans the raw plane data recorded by two observers..... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 6 April 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]



#### Workspace setup ####
library(tidyverse)
library(here)



#### Clean data ####
# load data
product_data <- read_csv(here("data", "01-raw_data", "hammer-4-product.csv"), show_col_types = FALSE)
raw_data <- read_csv(here("data", "01-raw_data", "hammer-4-raw.csv"), show_col_types = FALSE)

# merge data
merge_data <- raw_data %>%
  inner_join(product_data, by = c("product_id" = "id")) %>%
  select(
    nowtime,
    vendor,
    product_id,
    product_name,
    brand,
    current_price,
    old_price,
    units,
    price_per_unit
  )

# clean data
cleaned_data <- merge_data %>%
  filter(vendor %in% c("Walmart", "TandT")) %>%
  select(nowtime, vendor, current_price, old_price, product_name) %>%
  mutate(
    year = year(nowtime),
    month = month(nowtime),
    day = day(nowtime),
    current_price = parse_number(current_price),
    old_price = parse_number(old_price)
    ) %>%
  filter(str_detect(tolower(product_name), "beef")) %>%
  filter(!str_detect(tolower(product_name), 
                     "flavour|vermicelli|rice|noodles|noodle|seasoning|lasagna|broth|soup|ravioli|pasta|plant-based|bun"
                     )) %>%
  select(-nowtime) %>%
  tidyr::drop_na()



#### Save data ####
write_csv(cleaned_data, "data/02-analysis_data/soy_data.csv")
