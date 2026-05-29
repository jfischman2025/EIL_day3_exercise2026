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
library(rnaturalearth)
library(rnaturalearthdata)
library(sf)
library(ggrepel)

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

# map of PM2.5 concentration in 2023
df_2019 <- df |> filter(year == 2019)

world <- ne_countries(scale = "medium", returnclass = "sf")
world_pm <- left_join(world, df_2019, by = c("iso_a3" = "iso3c"))

pm_min <- min(df_2019$pm2.5, na.rm = TRUE)
pm_max <- max(df_2019$pm2.5, na.rm = TRUE)

pm_breaks <- pretty(c(pm_min, pm_max), n = 5)
pm_labels <- as.character(pm_breaks)
pm_labels[1] <- paste0(pm_labels[1], "\n(min)")
pm_labels[length(pm_labels)] <- paste0(pm_labels[length(pm_labels)], "\n(max)")

map <- ggplot(world_pm) +
  geom_sf(aes(fill = pm2.5), color = "white", linewidth = 0.1) +
  scale_fill_viridis_c(option = "magma", name = "PM2.5 (µg/m³)",
                       na.value = "grey80",
                       breaks = pm_breaks,
                       labels = pm_labels) +
  labs(title = "PM2.5 Air Pollution Concentration, 2019") +
  theme_void(base_size = 9) +
  theme(legend.position = "right")

ggsave(plot = map, "results/pm25_map_2019.png",
       width = 10, height = 6, dpi = 300)

# map of life expectancy in 2019
world_le <- left_join(world, df_2019, by = c("iso_a3" = "iso3c"))

le_min <- min(df_2019$life_exp, na.rm = TRUE)
le_max <- max(df_2019$life_exp, na.rm = TRUE)

le_breaks <- pretty(c(le_min, le_max), n = 5)
le_labels <- as.character(le_breaks)
le_labels[1] <- paste0(le_labels[1], "\n(min)")
le_labels[length(le_labels)] <- paste0(le_labels[length(le_labels)],
                                       "\n(max)")

map_le <- ggplot(world_le) +
  geom_sf(aes(fill = life_exp), color = "white", linewidth = 0.1) +
  scale_fill_viridis_c(option = "viridis", name = "Life Expectancy (years)",
                       na.value = "grey80",
                       breaks = le_breaks,
                       labels = le_labels) +
  labs(title = "Life Expectancy at Birth, 2019") +
  theme_void(base_size = 9) +
  theme(legend.position = "right")

ggsave(plot = map_le, "results/le_map_2019.png",
       width = 10, height = 6, dpi = 300)

# bar chart: top 5 and bottom 5 countries by PM2.5 in 2019
top5 <- df_2019 |> drop_na(pm2.5) |> slice_max(pm2.5, n = 5) |>
  mutate(country = fct_reorder(country, pm2.5))

pm_mean <- mean(df_2019$pm2.5, na.rm = TRUE)

bar <- ggplot(top5, aes(x = country, y = pm2.5)) +
  geom_col(fill = "#1a3a5c") +
  geom_hline(yintercept = pm_mean, color = "grey70",
             linetype = "dotted", linewidth = 1) +
  annotate("text", x = 0.5, y = pm_mean, label = "mean",
           vjust = -0.5, hjust = 0, size = 3, color = "grey70") +
  labs(x = NULL, y = "PM2.5 (µg/m³)",
       title = "Top 5 Countries by PM2.5 Exposure, 2019") +
  theme_minimal(base_size = 9) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave(plot = bar, "results/pm25_bar_2019.png",
       width = 8, height = 5, dpi = 300)

# time series of PM2.5 for selected countries
top1_code <- df_2019 |> drop_na(pm2.5) |>
  slice_max(pm2.5, n = 1) |> pull(iso3c)
bottom1_code <- df_2019 |> drop_na(pm2.5) |>
  slice_min(pm2.5, n = 1) |> pull(iso3c)

ts_df <- df |>
  filter(iso3c %in% c("USA", "CHN", "IND", top1_code, bottom1_code))

ts <- ggplot(ts_df, aes(x = year, y = pm2.5, color = country)) +
  geom_line() +
  scale_x_continuous(limits = c(1990, NA)) +
  scale_color_manual(values = c("#4e6b8c", "#8c4e4e", "#6b8c4e",
                                "#7a5c8c", "#8c7a4e")) +
  labs(x = NULL, y = "PM2.5 (µg/m³)",
       title = "PM2.5 Concentrations Over Time For Select Countries",
       color = NULL) +
  theme_minimal(base_size = 9) +
  theme(legend.position = "bottom")

ggsave(plot = ts, "results/pm25_timeseries.png",
       width = 8, height = 5, dpi = 300)

# faceted scatter: life expectancy by above/below mean PM2.5 in 2019
facet_df <- df_2019 |>
  drop_na(pm2.5, life_exp) |>
  mutate(pm_group = ifelse(pm2.5 > pm_mean,
                           "Above Mean PM2.5",
                           "Below Mean PM2.5"))

facet_plot <- ggplot(facet_df, aes(x = pm2.5, y = life_exp)) +
  geom_point(size = 1.5, alpha = 0.6, color = "#4e6b8c") +
  geom_smooth(method="lm", se=FALSE)+
  facet_wrap(~pm_group) +
  labs(x = "PM2.5 (µg/m³)", y = "Life Expectancy (years)",
       title = "Life Expectancy by PM2.5 Group, 2019") +
  theme_minimal(base_size = 9)

ggsave(plot = facet_plot, "results/le_pm_facet_2019.png",
       width = 10, height = 5, dpi = 300)

# ── shared prep for additional figures ──────────────────────────────────────

df_1990 <- df |> filter(year == 1990)

df_change_pm <- inner_join(
  df_1990 |> select(iso3c, country, pm25_1990 = pm2.5),
  df_2019 |> select(iso3c, pm25_2019 = pm2.5),
  by = "iso3c"
) |> mutate(pm25_change = pm25_2019 - pm25_1990)

df_change_le <- inner_join(
  df_1990 |> select(iso3c, country, le_1990 = life_exp),
  df_2019 |> select(iso3c, le_2019 = life_exp),
  by = "iso3c"
) |> mutate(le_change = le_2019 - le_1990)

df_decades <- df |>
  filter(year >= 1990) |>
  mutate(decade = case_when(
    year < 2000 ~ "1990s",
    year < 2010 ~ "2000s",
    TRUE        ~ "2010s"
  ))

# 01 - PM2.5 histogram 2019
g01 <- ggplot(df_2019 |> drop_na(pm2.5), aes(x = pm2.5)) +
  geom_histogram(fill = "#4e6b8c", color = "white", bins = 30) +
  labs(x = "PM2.5 (µg/m³)", y = "Count",
       title = "Distribution of PM2.5 Across Countries, 2019") +
  theme_minimal(base_size = 9)

ggsave(plot = g01, "results/01_pm25_histogram_2019.png",
       width = 8, height = 5, dpi = 300)

# 02 - PM2.5 top 10 and bottom 10 bar chart 2019
tb10_df <- bind_rows(
  df_2019 |> drop_na(pm2.5) |> slice_max(pm2.5, n = 10),
  df_2019 |> drop_na(pm2.5) |> slice_min(pm2.5, n = 10)
) |> mutate(country = fct_reorder(country, pm2.5))

g02 <- ggplot(tb10_df, aes(x = country, y = pm2.5)) +
  geom_col(fill = "#4e6b8c") +
  labs(x = NULL, y = "PM2.5 (µg/m³)",
       title = "Top 10 and Bottom 10 Countries by PM2.5, 2019") +
  theme_minimal(base_size = 9) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave(plot = g02, "results/02_pm25_top10_bottom10_2019.png",
       width = 10, height = 5, dpi = 300)

# 03 - Global mean PM2.5 trend
pm_trend <- df |>
  filter(year >= 1990) |>
  group_by(year) |>
  summarise(mean_pm25 = mean(pm2.5, na.rm = TRUE))

g03 <- ggplot(pm_trend, aes(x = year, y = mean_pm25)) +
  geom_line(color = "#4e6b8c") +
  geom_point(size = 1.5, color = "#4e6b8c") +
  labs(x = NULL, y = "Mean PM2.5 (µg/m³)",
       title = "Global Mean PM2.5 Concentration, 1990–2019") +
  theme_minimal(base_size = 9)

ggsave(plot = g03, "results/03_pm25_global_mean_trend.png",
       width = 8, height = 5, dpi = 300)

# 04 - Biggest changes in PM2.5 from 1990 to 2019
pm_change_df <- bind_rows(
  df_change_pm |> drop_na(pm25_change) |> slice_max(pm25_change, n = 5),
  df_change_pm |> drop_na(pm25_change) |> slice_min(pm25_change, n = 5)
) |> mutate(
  country   = fct_reorder(country, pm25_change),
  direction = ifelse(pm25_change > 0, "Increase", "Decrease")
)

g04 <- ggplot(pm_change_df,
              aes(x = country, y = pm25_change, fill = direction)) +
  geom_col() +
  scale_fill_manual(values = c("Increase" = "#8c4e4e",
                               "Decrease" = "#4e6b8c")) +
  labs(x = NULL, y = "Change in PM2.5 (µg/m³)", fill = NULL,
       title = "Largest Changes in PM2.5 Concentration, 1990–2019") +
  theme_minimal(base_size = 9) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "top")

ggsave(plot = g04, "results/04_pm25_change_1990_2019.png",
       width = 8, height = 5, dpi = 300)

# 05 - PM2.5 density by decade
g05 <- ggplot(df_decades |> drop_na(pm2.5),
              aes(x = pm2.5, color = decade, fill = decade)) +
  geom_density(alpha = 0.2) +
  scale_color_manual(values = c("1990s" = "#4e6b8c",
                                "2000s" = "#6b8c4e",
                                "2010s" = "#8c4e4e")) +
  scale_fill_manual(values  = c("1990s" = "#4e6b8c",
                                "2000s" = "#6b8c4e",
                                "2010s" = "#8c4e4e")) +
  labs(x = "PM2.5 (µg/m³)", y = "Density", color = NULL, fill = NULL,
       title = "Distribution of PM2.5 by Decade") +
  theme_minimal(base_size = 9) +
  theme(legend.position = "top")

ggsave(plot = g05, "results/05_pm25_decade_density.png",
       width = 8, height = 5, dpi = 300)

# 06 - Life expectancy histogram 2019
g06 <- ggplot(df_2019 |> drop_na(life_exp), aes(x = life_exp)) +
  geom_histogram(fill = "#4e7a6b", color = "white", bins = 20) +
  labs(x = "Life Expectancy (years)", y = "Count",
       title = "Distribution of Life Expectancy Across Countries, 2019") +
  theme_minimal(base_size = 9)

ggsave(plot = g06, "results/06_le_histogram_2019.png",
       width = 8, height = 5, dpi = 300)

# 07 - Life expectancy top 10 and bottom 10 bar chart 2019
le_tb10_df <- bind_rows(
  df_2019 |> drop_na(life_exp) |> slice_max(life_exp, n = 10),
  df_2019 |> drop_na(life_exp) |> slice_min(life_exp, n = 10)
) |> mutate(country = fct_reorder(country, life_exp))

g07 <- ggplot(le_tb10_df, aes(x = country, y = life_exp)) +
  geom_col(fill = "#4e7a6b") +
  labs(x = NULL, y = "Life Expectancy (years)",
       title = "Top 10 and Bottom 10 Countries by Life Expectancy, 2019") +
  theme_minimal(base_size = 9) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave(plot = g07, "results/07_le_top10_bottom10_2019.png",
       width = 10, height = 5, dpi = 300)

# 08 - Global mean life expectancy trend
le_trend <- df |>
  filter(year >= 1990) |>
  group_by(year) |>
  summarise(mean_le = mean(life_exp, na.rm = TRUE))

g08 <- ggplot(le_trend, aes(x = year, y = mean_le)) +
  geom_line(color = "#4e7a6b") +
  geom_point(size = 1.5, color = "#4e7a6b") +
  labs(x = NULL, y = "Mean Life Expectancy (years)",
       title = "Global Mean Life Expectancy, 1990–2023") +
  theme_minimal(base_size = 9)

ggsave(plot = g08, "results/08_le_global_mean_trend.png",
       width = 8, height = 5, dpi = 300)

# 09 - Biggest changes in life expectancy from 1990 to 2019
le_change_df <- bind_rows(
  df_change_le |> drop_na(le_change) |> slice_max(le_change, n = 5),
  df_change_le |> drop_na(le_change) |> slice_min(le_change, n = 5)
) |> mutate(
  country   = fct_reorder(country, le_change),
  direction = ifelse(le_change > 0, "Increase", "Decrease")
)

g09 <- ggplot(le_change_df,
              aes(x = country, y = le_change, fill = direction)) +
  geom_col() +
  scale_fill_manual(values = c("Increase" = "#4e7a6b",
                               "Decrease" = "#8c4e4e")) +
  labs(x = NULL, y = "Change in Life Expectancy (years)", fill = NULL,
       title = "Largest Changes in Life Expectancy, 1990–2019") +
  theme_minimal(base_size = 9) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "top")

ggsave(plot = g09, "results/09_le_change_1990_2019.png",
       width = 8, height = 5, dpi = 300)

# 10 - Life expectancy density by decade
g10 <- ggplot(df_decades |> drop_na(life_exp),
              aes(x = life_exp, color = decade, fill = decade)) +
  geom_density(alpha = 0.2) +
  scale_color_manual(values = c("1990s" = "#4e6b8c",
                                "2000s" = "#6b8c4e",
                                "2010s" = "#8c4e4e")) +
  scale_fill_manual(values  = c("1990s" = "#4e6b8c",
                                "2000s" = "#6b8c4e",
                                "2010s" = "#8c4e4e")) +
  labs(x = "Life Expectancy (years)", y = "Density",
       color = NULL, fill = NULL,
       title = "Distribution of Life Expectancy by Decade") +
  theme_minimal(base_size = 9) +
  theme(legend.position = "top")

ggsave(plot = g10, "results/10_le_decade_density.png",
       width = 8, height = 5, dpi = 300)

# ── combined PM2.5 + life expectancy figures ─────────────────────────────────

# 11 - Scatter with labeled outliers (2019)
scatter_df <- df_2019 |> drop_na(pm2.5, life_exp)
fit <- lm(life_exp ~ pm2.5, data = scatter_df)
scatter_df <- scatter_df |>
  mutate(resid = abs(residuals(fit))) |>
  mutate(label = ifelse(resid > quantile(resid, 0.93), country, NA))

g11 <- ggplot(scatter_df, aes(x = pm2.5, y = life_exp)) +
  geom_point(size = 1.5, alpha = 0.5, color = "#4e6b8c") +
  geom_smooth(method = "lm", se = FALSE, color = "#8c4e4e",
              linewidth = 0.7) +
  geom_text_repel(aes(label = label), size = 2.5, max.overlaps = 20) +
  labs(x = "PM2.5 (µg/m³)", y = "Life Expectancy (years)",
       title = "PM2.5 vs. Life Expectancy, 2019") +
  theme_minimal(base_size = 9)

ggsave(plot = g11, "results/11_scatter_labeled_2019.png",
       width = 8, height = 6, dpi = 300)


# 13 - Change in PM2.5 vs. change in life expectancy per country
both_change <- inner_join(df_change_pm, df_change_le,
                          by = c("iso3c", "country")) |>
  drop_na(pm25_change, le_change)

g13 <- ggplot(both_change, aes(x = pm25_change, y = le_change)) +
  geom_point(size = 1.5, alpha = 0.5, color = "#4e6b8c") +
  geom_smooth(method = "lm", se = FALSE, color = "#8c4e4e",
              linewidth = 0.7) +
  geom_hline(yintercept = 0, linetype = "dotted", color = "grey60") +
  geom_vline(xintercept = 0, linetype = "dotted", color = "grey60") +
  labs(x = "Change in PM2.5 (µg/m³)",
       y = "Change in Life Expectancy (years)",
       title = "Change in PM2.5 vs. Life Expectancy, 1990–2019") +
  theme_minimal(base_size = 9)

ggsave(plot = g13, "results/13_joint_change_scatter.png",
       width = 8, height = 6, dpi = 300)

# 14 - Selected countries' paths in PM2.5/life expectancy space over time
path_df <- df |>
  filter(iso3c %in% c("USA", "CHN", "IND", top1_code, bottom1_code),
         year >= 1990) |>
  drop_na(pm2.5, life_exp)

g14 <- ggplot(path_df, aes(x = pm2.5, y = life_exp, color = country)) +
  geom_path(arrow = arrow(length = unit(0.15, "cm"), type = "closed"),
            linewidth = 0.7) +
  geom_point(data = path_df |> filter(year == 1990), size = 2) +
  scale_color_manual(values = c("#4e6b8c", "#8c4e4e", "#6b8c4e",
                                "#7a5c8c", "#8c7a4e")) +
  labs(x = "PM2.5 (µg/m³)", y = "Life Expectancy (years)",
       color = NULL,
       title = "PM2.5 vs. Life Expectancy Trajectories, 1990–2019",
       caption = "Dots mark 1990; arrows show direction of change") +
  theme_minimal(base_size = 9) +
  theme(legend.position = "bottom")

ggsave(plot = g14, "results/14_country_paths.png",
       width = 8, height = 6, dpi = 300)

# 15 - Global mean PM2.5 vs. global mean life expectancy connected scatter
global_means <- df |>
  filter(year >= 1990) |>
  group_by(year) |>
  summarise(mean_pm25 = mean(pm2.5, na.rm = TRUE),
            mean_le   = mean(life_exp, na.rm = TRUE))

g15 <- ggplot(global_means, aes(x = mean_pm25, y = mean_le)) +
  geom_path(arrow = arrow(length = unit(0.2, "cm"), type = "closed"),
            color = "#4e6b8c", linewidth = 0.7) +
  geom_point(size = 1.5, color = "#4e6b8c") +
  geom_text_repel(aes(label = year), size = 2.5, max.overlaps = 10) +
  labs(x = "Mean PM2.5 (µg/m³)", y = "Mean Life Expectancy (years)",
       title = "Global Mean PM2.5 vs. Life Expectancy, 1990–2019",
       caption = "Each point is one year; arrow shows direction over time") +
  theme_minimal(base_size = 9)

ggsave(plot = g15, "results/15_global_mean_path.png",
       width = 8, height = 6, dpi = 300)
