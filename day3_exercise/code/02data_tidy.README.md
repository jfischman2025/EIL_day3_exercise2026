# data_tidy.R — README

## Purpose
This script combines and cleans the pm2.5 and life expectancy data that was pulled from data_pull.r

## Inputs
- "pm25_data_raw.csv", "life_exp_data_raw.csv"

## Outputs
- "pm23_le_comb_clean.csv" - this is the combined and clean dataset that is now ready to be analyzed

## Data Sources
- World Bank Development Indicators
  - PM2.5 indicator code: EN.ATM.PM25.MC.M3
  - Life expectancy indicator code: SP.DYN.LE00.IN
  - Coverage: all countries, 1960–2023
  - Access: public, no authentication required

## Dependencies
- R package: WDI (version 2.7.0)
- R package: tidyverse (version 2.0.0)
- R version: 4.6.0 (2026-04-24)

## How to Run
Run the script

## Notes
- Any known data quality issues (e.g., PM2.5 has limited pre-2000 coverage)
- Date script was last run successfully