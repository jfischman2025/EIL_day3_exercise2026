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
library(ggplot2)

#setwd
setwd("/Users/jfischman/Library/CloudStorage/Dropbox/Josie/Github/Untitled/EIL_day3_exercise2026/day3_exercise")

# load inputs
df <- read.csv("data/pm25_le_comb_clean.csv")

# scatterplot
p <- ggplot(data=df, aes(x=life_exp, y=pm2.5))+ 
    geom_point(size=0.5, alpha=0.3)+
    geom_smooth(method="lm", se=FALSE)+
    labs(x = "Life Expectancy at Birth", y = "PM2.5 Exposure (µg/m³)")+
    theme_minimal()
ggsave(plot=p, "results/le_pm_scatter.png")