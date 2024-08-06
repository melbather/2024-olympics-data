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
          h3(htmlOutput(ns("map_title"))),
          plotlyOutput(ns("map_plot"))
        )
      )
    )
  )
  
}




#Map Server ----------------------------------------------------

map_server <- function(id, parent, label = "map_server") {
  
  moduleServer(id, function(input, output, session) {
    
    output$map_title <- renderUI({
      req(input$medal_type, input$stat_type)
      if(input$medal_type == "Total medals") title_pt1 <- "Total"
      else if(input$medal_type == "Gold") title_pt1 <- "Number of Gold"
      else if(input$medal_type == "Silver") title_pt1 <- "Number of Silver"
      else title_pt1 <- "Number of Bronze"
      
      if(input$stat_type == "Medals per capita") title_ending <- "Per Capita"
      else title_ending <- "by Country"
      
      paste(title_pt1, "Medals", title_ending)
    })
    
    output$map_plot <- renderPlotly({
      req(input$medal_type, input$stat_type)
      
      if(input$stat_type == "Number of medals") medal_vars <- medal_cols
      else medal_vars <- medal_types_per_capita_vars
      
      if(input$medal_type == "Total medals") fill_var <- medal_vars[1]
      else if(input$medal_type == "Gold") fill_var <- medal_vars[2]
      else if(input$medal_type == "Silver") fill_var <- medal_vars[3]
      else fill_var <- medal_vars[4]
    
      world <- ne_countries(scale = "medium", returnclass = "sf")
      p <- ggplot(all_data, aes(fill = !!sym(fill_var))) +
        geom_sf(size = 0.1) +
        scale_fill_continuous(type = "viridis", name = input$stat_type) +
        theme_bw()
      ggplotly(p)
    })
  })
  
}







