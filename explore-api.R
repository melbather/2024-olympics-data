library(httr)
library(jsonlite)

base_URL <- "https://apis.codante.io/olympic-games/"
#medals <- GET(paste0(base_URL, "countries"))
#results <- fromJSON(content(medals, "text", encoding = "UTF-8"))$data

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
results_df <- do.call(rbind, standardised_results)
