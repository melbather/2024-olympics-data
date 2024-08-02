library(ggplot2)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(dplyr)
library(gt)

# get world populations data
country_pops <- countrypops %>%
  filter(year == 2022) %>%
  select(country_code_3, population)

medal_cols <- c("gold_medals", "silver_medals", "bronze_medals", "total_medals")

all_data <- world %>%
  left_join(results, join_by(gu_a3 == id), keep = TRUE) %>%
  select(-c(name.y, continent.y)) %>%
  mutate(across(all_of(medal_cols), ~ ifelse(is.na(.), 0, .))) %>%
  left_join(country_pops, join_by(gu_a3 == country_code_3)) %>%
  mutate(gold_medals_per_capita = gold_medals/population * 1000000,
         silver_medals_per_capita = silver_medals/population * 1000000,
         bronze_medals_per_capita = bronze_medals/population * 1000000,
         total_medals_per_capita = total_medals/population * 1000000)

theme_set(theme_bw())
world <- ne_countries(scale = "medium", returnclass = "sf")
ggplot(test, aes(fill = total_medals)) +
  geom_sf()

