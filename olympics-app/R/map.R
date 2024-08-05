#Map UI ---------------------------------------------------------------

map_ui <- function(id, label = "map_ui") {
  ns <- NS(id)
  tagList(
    fluidRow(
      #Sidebar 
      sidebarLayout(
        sidebarPanel(
          selectInput(ns("medal_type"),
                      "Medal Type",
                      choices = medal_types),
          selectInput(ns("stat_type"),
                      "Measurement",
                      choices = stat_types)
        ),
        
        # Main Panel
        mainPanel(
          plotlyOutput(ns("map_plot"))
        )
      )
    )
  )
  
}




#Map Server ----------------------------------------------------

map_server <- function(id, parent, label = "map_server") {
  
  moduleServer(id, function(input, output, session) {
    
    output$map_plot <- renderPlotly({
      req(input$medal_type, input$stat_type)
      world <- ne_countries(scale = "medium", returnclass = "sf")
      p <- ggplot(all_data, aes(fill = total_medals)) +
        geom_sf() +
        theme_bw()
      ggplotly(p)
    })
  })
  
}







