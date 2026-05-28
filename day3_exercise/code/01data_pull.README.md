# data_pull.R — README

## Purpose
This script uses the WDI package to pull in life expectancy and pm2.5 data into the data folder

## Inputs
- None (pulls directly from World Bank API via WDI package)

## Outputs
- data/pm25_data_raw.csv — PM2.5 air pollution, mean annual exposure (country-year)
- data/life_exp_data_raw.csv — Life expectancy at birth, total (country-year)

## Data Sources
- World Bank Development Indicators
  - PM2.5 indicator code: EN.ATM.PM25.MC.M3
  - Life expectancy indicator code: SP.DYN.LE00.IN
  - Coverage: all countries, 1960–2023
  - Access: public, no authentication required

## Dependencies
- R package: WDI (version 2.7.0)
- R version: 4.6.0 (2026-04-24)

## How to Run
Run the script

## Notes
- Any known data quality issues (e.g., PM2.5 has limited pre-2000 coverage)
- Date script was last run successfully