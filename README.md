# EIL Day 3 Exercise
Practice with data compiling, coding, and organization

---
contributors:
  - Josie Fischman
version: 1.2.rc1
---

## Overview

- This project focuses on practicing data compiling, coding, and summarizing with R, Claude, and Github. 

## Data Availability and Provenance

Both datasets are publicly available through the World Bank Development Indicators (WDI) API. No authentication or registration is required. Data were pulled programmatically using the `WDI` R package.

| Data | Indicator Code | Coverage | Provided |
|------|---------------|----------|---------|
| PM2.5 air pollution, mean annual exposure | EN.ATM.PM25.MC.M3 | Country-year, 1960–2023 | Yes |
| Life expectancy at birth, total | SP.DYN.LE00.IN | Country-year, 1960–2023 | Yes |

### Statement about Rights

- [ ] I certify that the author(s) of the manuscript have legitimate access to and permission to use the data used in this manuscript.

### License for Data

Both datasets are in the public domain (World Bank open data).

## Dataset List

| Data file | Source | Notes | Provided |
|-----------|--------|-------|---------|
| `data/pm25_data_raw.csv` | World Bank WDI | Raw pull, all countries and regions | Yes |
| `data/life_exp_data_raw.csv` | World Bank WDI | Raw pull, all countries and regions | Yes |
| `data/pm25_le_comb_clean.csv` | Derived | Merged, countries only (aggregates dropped) | Yes |

## Computational Requirements

### Software

- R (version 4.6.0)
  - `WDI` (version 2.7.0)
  - `tidyverse` (version 2.0.0)

### Runtime

> 30 seconds

## Description of Programs

| Script | README | Purpose |
|--------|--------|---------|
| `code/01data_pull.r` | `code/01data_pull.README.md` | Pulls raw data from World Bank API |
| `code/02data_tidy.r` | `code/02data_tidy.README.md` | Merges and cleans raw datasets |
| `code/03summarise.r` | `code/03summarise.README.md` | Generates summary statistics tables |

## Instructions to Replicators

1. Open R and set working directory to `day3_exercise/`
2. Run `code/01data_pull.r` — writes raw CSVs to `data/`
3. Run `code/02data_tidy.r` — writes `data/pm25_le_comb_clean.csv`
4. Run `code/03summarise.r` — writes summary tables to `results/`

## References

World Bank. World Development Indicators. PM2.5 air pollution, mean annual exposure (EN.ATM.PM25.MC.M3). Accessed May 2026. https://data.worldbank.org

World Bank. World Development Indicators. Life expectancy at birth, total (SP.DYN.LE00.IN). Accessed May 2026. https://data.worldbank.org
