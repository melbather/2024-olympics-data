#Map UI ---------------------------------------------------------------

map_ui <- function(id, label = "map_ui") {
  ns <- NS(id)
  tagList(
  fluidPage(
    fluidRow(
      column(12,
             wellPanel(
               selectInput(ns("medal_type"),
                           "Medal Type",
                           choices = medal_types),
               selectInput(ns("stat_type"),
                           "Measurement",
                           choices = stat_types),
               p("Note: the map may be slow to render. It is best viewed on desktop."),
               p("Select the Autoscale option on the top right of the map upon hover for best viewing."),
               p("Hover over countries to view numbers. Table coming soon!")
             )
      )
    ),
    fluidRow(
      column(12,
               h3(htmlOutput(ns("map_title"))),
               br(),
               plotlyOutput(ns("map_plot"))
      )
    )
  ))
  
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
    
      world <- ne_countries(scale = 110, returnclass = "sf")
      p <- ggplot(all_data, aes(fill = !!sym(fill_var), 
                  text = paste0("Country: ", name_en, "\n",
                               input$stat_type, ": ", !!sym(fill_var)))) +
        geom_sf(size = 0.1, color = "white", lwd = 0.05) +
        scale_fill_continuous(type = "viridis", name = input$stat_type) +
        theme_bw()
      ggplotly(p, tooltip = "text")
    })
  })
  
}







