##########################################################
# Author: Josie Fischman
# Date: 05/28/2026
# Project: EIL Day 3 data exercise
# Inputs: API keys
# output: air pollution and life expectancy data sets
##########################################################
# load libraries

library(WDI)
#setwd

setwd("/Users/jfischman/Library/CloudStorage/Dropbox/Josie/Github/Untitled/EIL_day3_exercise2026/day3_exercise")
# search for the indicator codes
pm_code <- WDIsearch("PM2.5 air pollution")
le_code <- WDIsearch("life expectancy at birth, total")

# pull data
pm <- WDI(country = "all", indicator = "EN.ATM.PM25.MC.M3", start = 1960, end = 2023)
le <- WDI(country="all", indicator = "SP.DYN.LE00.IN", start = 1960, end = 2023)

# save into dataframe
write.csv(pm, "data/pm25_data_raw.csv", row.names=FALSE)
write.csv(le, "data/life_exp_data_raw.csv", row.names=FALSE)
