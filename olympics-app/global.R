#~~~~~~~~~~~~~~~~~~~ Global File ~~~~~~~~~~~~~~~~~~~~~~~

# Read libraries
library(shiny)
library(shinydashboard)
library(httr)
library(jsonlite)
library(ggplot2)
library(plotly)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(dplyr)
library(DT)

# Set dropdown selections
medal_types <- c("Total medals", "Gold", "Silver", "Bronze")
stat_types <- c("Number of medals", "Medals per capita")
medal_types_per_capita_vars <- c("total_medals_per_capita", "gold_medals_per_capita",
                                 "silver_medals_per_capita", "bronze_medals_per_capita")

# Connect to API + get data
base_URL <- "https://apis.codante.io/olympic-games/"
all_results <- list()
page <- 1
per_page <- 50

repeat {
  response <- GET(paste0(base_URL, "countries?page=", page, "&per_page=", per_page))
  data <- fromJSON(content(response, "text", encoding = "UTF-8"))$data
  
  if (length(data) == 0) break
  
  all_results <- c(all_results, list(data))
  page <- page + 1
}

all_columns <- unique(unlist(lapply(all_results, function(df) names(df))))

standardise_df <- function(df, all_columns) {
  df <- as.data.frame(df)
  missing_cols <- setdiff(all_columns, names(df))
  df[missing_cols] <- NA 
  df <- df[, all_columns]
  return(df)
}

standardised_results <- lapply(all_results, standardise_df, all_columns)
results <- do.call(rbind, standardised_results)

# Consolidate data
world <- ne_countries(scale = "medium", returnclass = "sf")
medal_cols <- c("total_medals", "gold_medals", "silver_medals", "bronze_medals")
all_data <- world %>%
  left_join(results, join_by(gu_a3 == id), keep = TRUE) %>%
  select(-c(name.y, continent.y)) %>%
  mutate(across(all_of(medal_cols), ~ ifelse(is.na(.), 0, .))) %>%
  mutate(gold_medals_per_capita = round(gold_medals/pop_est * 1000000, 4),
         silver_medals_per_capita = round(silver_medals/pop_est * 1000000, 4),
         bronze_medals_per_capita = round(bronze_medals/pop_est * 1000000, 4),
         total_medals_per_capita = round(total_medals/pop_est * 1000000, 4))


