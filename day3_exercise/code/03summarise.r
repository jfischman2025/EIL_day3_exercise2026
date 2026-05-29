##########################################################
# Author: Josie Fischman
# Date: 05/28/2026
# Project: EIL Day 3 data exercise
# Inputs: "pm25_le_comb_clean.csv"
# output: pm25_summary.csv, le_summary.csv
##########################################################
# load libraries
library(tidyverse)
library(WDI)
library(xtable)

#setwd
setwd("/Users/jfischman/Library/CloudStorage/Dropbox/Josie/Github/Untitled/EIL_day3_exercise2026/day3_exercise")

# load inputs
df <- read.csv("data/pm25_le_comb_clean.csv")

# calculate summary statistics
pm_sum <- df |> summarise(
  mean = mean(pm2.5, na.rm = TRUE),
  sd   = sd(pm2.5, na.rm = TRUE),
  min  = min(pm2.5, na.rm = TRUE),
  max  = max(pm2.5, na.rm = TRUE),
  num = sum(!is.na(pm2.5))
)

le_sum <- df |> summarise(
  mean = mean(life_exp, na.rm = TRUE),
  sd   = sd(life_exp, na.rm = TRUE),
  min  = min(life_exp, na.rm = TRUE),
  max  = max(life_exp, na.rm = TRUE),
  num = sum(!is.na(life_exp))
)

# save tables to results
write.csv(pm_sum, "results/pm25_summary.csv", row.names=FALSE)
write.csv(le_sum, "results/le_summary.csv", row.names=FALSE)

# combine into one table for latex
combined_sum <- bind_rows(
  pm_sum |> mutate(variable = "PM2.5 (µg/m³)", .before = mean),
  le_sum |> mutate(variable = "Life Expectancy (years)", .before = mean)
) |>
  rename(
    Variable = variable,
    Mean     = mean,
    SD       = sd,
    Min      = min,
    Max      = max,
    N        = num
  )

print(
  xtable(combined_sum,
         caption = "Summary Statistics",
         label   = "tab:summary",
         digits  = c(0, 0, 2, 2, 2, 2, 0)),
  include.rownames  = FALSE,
  caption.placement = "top",
  file = "results/summary_stats.tex"
)

