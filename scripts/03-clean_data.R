#### Preamble ####
# Purpose: To load raw product and transaction data, merge and clean the datasets by filtering and transforming columns, and save the cleaned and processed data into parquet files for further analysis.
# Author: Ziheng Zhong
# Date: 20 November 2024
# Contact: ziheng.zhong@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
  # - Package must be installed
  # - 02-download_data.R must have been run



#### Workspace setup ####
library(tidyverse)
library(arrow)
library(here)

# load data
product_data <- read_csv(here("data", "01-raw_data", "hammer-4-product.csv"), show_col_types = FALSE)
raw_data <- read_csv(here("data", "01-raw_data", "hammer-4-raw.csv"), show_col_types = FALSE)



#### Clean data ####
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

# ppu data (price_per_unit)
ppu_data <- merge_data %>%
  filter(vendor %in% c("Walmart", "TandT")) %>%
  filter(str_detect(tolower(product_name), "beef")) %>%
  select(vendor, price_per_unit)

# clean data
cleaned_data <- merge_data %>%
  filter(vendor %in% c("Walmart", "TandT")) %>%
  select(nowtime, vendor, current_price, old_price, product_name, price_per_unit) %>%
  mutate(
    year = year(nowtime),
    month = month(nowtime),
    day = day(nowtime),
    current_price = parse_number(current_price),
    old_price = parse_number(old_price),
    price_per_unit = str_extract(price_per_unit, "\\$[0-9\\.]+") %>% 
      str_remove("\\$") %>%
      as.numeric(),
    price_per_unit = ifelse(is.na(price_per_unit), 0, price_per_unit)
  ) %>%
  filter(str_detect(tolower(product_name), "beef")) %>%
  filter(!str_detect(tolower(product_name), 
                     "flavour|vermicelli|rice|noodles|noodle|seasoning|lasagna|broth|soup|ravioli|pasta|plant-based|bun"
  )) %>%
  select(-nowtime) %>%
  tidyr::drop_na()



#### Save data ####
write_parquet(merge_data, here("data", "02-analysis_data", "merged_data.parquet"))
write_parquet(ppu_data, here("data", "02-analysis_data", "ppu_data.parquet"))
write_parquet(cleaned_data, here("data", "02-analysis_data", "beef_data.parquet"))


