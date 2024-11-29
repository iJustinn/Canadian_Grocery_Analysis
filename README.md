# Canadian_Grocery_Analysis

This repository provides all the necessary information to replicate Ziheng Zhong's Canadian grocery analysis paper.

## Paper Overview

This paper utilized data from [Project Hammer](https://jacobfilipp.com/hammer/) to analyze beef pricing in the Canadian retail sector, with a focus on comparing Walmart and T&T. Using Bayesian linear regression, the study found that historical pricing trends and vendor strategies significantly influence current beef prices. Walmart demonstrates a preference for stable pricing, while T&T shows greater variability, likely reflecting different approaches to market positioning. The findings underscore the role of both market dynamics and vendor practices in shaping beef prices, offering useful information for retailers aiming to refine pricing strategies and for policymakers addressing food affordability. The study also highlights how cultural preferences and retail strategies interact in determining food prices.
## File Structure

The files for this research are organized in this repository as follows:

-   `data/00-simulated_data`: the simulated data used as the preview of actual dataset

-   `data/01-raw_data`: the raw data used for analysis

-   `data/02-analysis_data`: the cleaned data used for fuurther analysis

-   `models`: the model used in the paper

-   `other/datasheet`: the detailed datasheet of Project Hammer dataset

-   `other/sketches`: previews of the charts and models included in the final research paper

-   `other/llm`: records of multiple conversations with ChatGPT that assisted in building this project

-   `paper`: files used to generate the paper, such as Quarto and bibliography files, as well as the research paper itself

-   `scripts`: R code used for data simulation, downloading, cleaning, charting , modeling and testing

## Large Language Model (LLM) usage statement

This project utilized ChatGPT (ChatGPT 4o model) to assist during the research, development, and writing processes. All records of usage can be found in the `other/llm` folder of this repository.