#### Preamble ####
# Purpose: To download a zip file containing raw data from a specified URL, extract its contents into a structured directory, and optionally load and preview the first CSV file to ensure successful extraction and data integrity.
# Author: Ziheng Zhong
# Date: 20 November 2024
# Contact: ziheng.zhong@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
  # - Package must be installed



#### Workspace setup ####
# load library
library(httr)
library(here)
library(utils)



#### Download data ####
# Specify the URL of the zip file
url <- "https://jacobfilipp.com/hammerdata/hammer-5-csv.zip"

# Specify the local file path for the zip file using `here`
zip_file <- here("data", "01-raw_data", "raw.zip")

# Create the directory structure if it doesn't exist
dir.create(dirname(zip_file), recursive = TRUE, showWarnings = FALSE)

# Download the zip file
response <- GET(url, write_disk(zip_file, overwrite = TRUE))

# Check the status of the download
if (status_code(response) == 200) {
  message("Zip file downloaded successfully and saved as: ", zip_file)
  
  # Extract the zip file directly into the `01-raw_data` folder
  unzip_dir <- here("data", "01-raw_data")
  unzip(zip_file, exdir = unzip_dir)
  message("Zip file extracted directly to the directory: ", unzip_dir)
  
  # List the extracted files
  extracted_files <- list.files(unzip_dir, full.names = TRUE)
  print("Extracted files:")
  print(extracted_files)
  
  # Optional: Load and preview the first CSV file
  csv_file <- extracted_files[grep("\\.csv$", extracted_files)][1] # Select the first CSV
  if (!is.na(csv_file)) {
    dataset <- read.csv(csv_file)
    print(head(dataset))
  } else {
    message("No CSV files found in the extracted content.")
  }
  
} else {
  message("Failed to download the zip file. Status code: ", status_code(response))
}

         
