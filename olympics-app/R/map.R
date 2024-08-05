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
      
      if(input$stat_type == "Number of medals") medal_vars <- medal_cols
      else medal_vars <- medal_types_per_capita_vars
      
      if(input$medal_type == "Total medals") fill_var <- medal_vars[1]
      else if(input$medal_type == "Gold") fill_var <- medal_vars[2]
      else if(input$medal_type == "Silver") fill_var <- medal_vars[3]
      else fill_var <- medal_vars[4]
    
      world <- ne_countries(scale = "medium", returnclass = "sf")
      #browser()
      p <- ggplot(all_data, aes(fill = !!sym(fill_var))) +
        geom_sf() +
        #scale_color_gradient(low = "blue", high = "red") +
        theme_bw()
      ggplotly(p)
    })
  })
  
}







