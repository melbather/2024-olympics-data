library(httr)
library(jsonlite)

base_URL <- "https://apis.codante.io/olympic-games/"
medals <- GET(paste0(base_URL, "countries"))
results <- fromJSON(content(medals, "text", encoding = "UTF-8"))$data