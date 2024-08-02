#Read in modules
source("global.R")
source("R/get-data.R", local = TRUE)
source("R/map.R", local = TRUE)
source("R/tech_info.R", local = TRUE)

ui <- fluidPage(
  tags$head(
    includeCSS("www/style.css")
  ),
  #Navigation
  tabBox(width = 12,
         id = "primary_box",
         tabPanel(value = "map",
                  h3(id = "nav_title", "Map"),
                  map_ui(id = "map")),
         tabPanel(value = "info",
                  h3(id = "nav_title", "Info"),
                  info_ui(id = "info"))
  )
)

server <- function(input, output) {
  map_server(id = "map", parent = session)
  info_server(id = "info", parent = session)
}

shinyApp(ui = ui, server = server)
