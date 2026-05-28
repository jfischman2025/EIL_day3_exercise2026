##########################################################
# Author: Josie Fischman
# Date: 05/28/2026
# Project: EIL Day 3 data exercise
# Inputs: "pm25_data_raw.csv", "life_exp_data_raw.csv"
# output: "pm25_le_comb_clean.csv"
##########################################################
# load libraries
library(tidyverse)
library(WDI)

#setwd
setwd("/Users/jfischman/Library/CloudStorage/Dropbox/Josie/Github/Untitled/EIL_day3_exercise2026/day3_exercise")

# load inputs
pm25 <- read.csv("data/pm25_data_raw.csv")
life_e <- read.csv("data/life_exp_data_raw.csv")

# rename columns
pm25 <- rename(pm25, pm2.5 = EN.ATM.PM25.MC.M3)
life_e <- rename(life_e, life_exp = SP.DYN.LE00.IN)

# merge dfs
combined <- inner_join(pm25, life_e, by = c("country", "iso2c", "iso3c", "year"))

#find list of countries
countries <- WDI_data$country
countries <- countries |> filter(region != "Aggregates")
codes <- countries[, 1]
# drop non-country rows
combined <- combined |> filter(iso3c %in% codes)

# write new combined csv
write.csv(combined, "data/pm25_le_comb_clean.csv", row.names=FALSE)
