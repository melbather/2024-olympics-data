library(ggplot2)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(dplyr)

test <- world %>%
  left_join(results, join_by(gu_a3 == id), keep = TRUE) %>%
  select(-c(name.y, continent.y)) %>%
  mutate(gold_medals = case_when(is.na(gold_medals) ~ 0,
                                 TRUE ~ gold_medals),
         silver_medals = case_when(is.na(silver_medals) ~ 0,
                                 TRUE ~ silver_medals),
         bronze_medals = case_when(is.na(bronze_medals) ~ 0,
                                 TRUE ~ bronze_medals),
         total_medals = case_when(is.na(total_medals) ~ 0,
                                   TRUE ~ total_medals))

theme_set(theme_bw())
world <- ne_countries(scale = "medium", returnclass = "sf")
ggplot(test, aes(fill = total_medals)) +
  geom_sf()

