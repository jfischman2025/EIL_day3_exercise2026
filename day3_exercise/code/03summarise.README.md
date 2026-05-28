# 03 summarise.R — README

## Purpose
This script creates two summary tables from the combined dataset pm25_le_comb_clean.csv

## Inputs
- "pm25_le_comb_clean.csv"

## Outputs
- le_summary.csv
- pm25_summary.csv

## Data Sources
- World Bank Development Indicators
  - PM2.5 indicator code: EN.ATM.PM25.MC.M3
  - Life expectancy indicator code: SP.DYN.LE00.IN
  - Coverage: all countries, 1960–2023
  - Access: public, no authentication required

## Dependencies
- R package: tidyverse (version 2.0.0)
- R version: 4.6.0 (2026-04-24)

## How to Run
Run the script

## Notes
- Any known data quality issues (e.g., PM2.5 has limited pre-2000 coverage)
- Date script was last run successfully