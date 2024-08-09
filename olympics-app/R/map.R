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
               HTML("<b>Important notes:</b>"),
               p("The map may be slow to render. It is best viewed on desktop."),
               p("Per capita calculations can vary based on population estimates used. View the Info tab 
                 for the source of the population estimates used in this app."),
               p("Select the Autoscale option on the top right of the map upon hover for best viewing."),
               p("Hover over countries to view numbers. Some countries are very small, so view the table 
                 below if you cannot see them on the map.")
             )
      )
    ),
    div(style = "padding: 0px 0px; margin-top:-3em",
    fluidRow(
      column(12,
             h3(htmlOutput(ns("map_title"))),
             br(),
             plotlyOutput(ns("map_plot")),
             br(),
             dataTableOutput(ns("medals_table")))
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
      
      if(input$stat_type == "Medals per capita") title_ending <- "Per Capita (per 1 million inhabitants)"
      else title_ending <- "by Country"
      
      paste(title_pt1, "Medals", title_ending)
    })
    
    dat <- reactive({
      req(input$medal_type, input$stat_type)
      
      if(input$stat_type == "Number of medals") medal_vars <- medal_cols
      else medal_vars <- medal_types_per_capita_vars
      
      if(input$medal_type == "Total medals") fill_var <- medal_vars[1]
      else if(input$medal_type == "Gold") fill_var <- medal_vars[2]
      else if(input$medal_type == "Silver") fill_var <- medal_vars[3]
      else fill_var <- medal_vars[4]
      
      cols_to_remove <- medal_vars[medal_vars != fill_var]
      
      all_data %>%
        rename(fill_var = fill_var)
    })
    
    output$map_plot <- renderPlotly({
      req(dat(), input$medal_type, input$stat_type)
      
      col_lim <- dat() %>% 
        pull(fill_var) %>% 
        max(na.rm = TRUE) %>% 
        ceiling()
      
      world <- ne_countries(scale = 110, returnclass = "sf")
      
      p <- ggplot(dat(), aes(fill = fill_var, 
                  text = paste0("Country: ", name_en, "\n",
                               input$stat_type, ": ", fill_var))) +
        geom_sf(size = 0.1, color = "white", lwd = 0.05) +
        scale_fill_continuous(type = "viridis", name = input$stat_type, limits = c(0, col_lim)) +
        theme_bw()
      ggplotly(p, tooltip = "text")
    })
    
    output$medals_table = renderDataTable({
      all_data %>% 
        select(name_en, all_of(medal_cols), gold_medals_per_capita, silver_medals_per_capita, 
               bronze_medals_per_capita, total_medals_per_capita) %>%
        arrange(desc(total_medals_per_capita)) %>%
        rename(Country = name_en, `Total medals` = total_medals, `Gold medals` = gold_medals,
               `Silver medals` = silver_medals, `Bronze medals` = bronze_medals, 
               `Total medals per capita` = total_medals_per_capita, `Gold medals per capita` = gold_medals_per_capita, 
               `Silver medals per capita` = silver_medals_per_capita,`Bronze medals per capita` = bronze_medals_per_capita) %>%
        as.data.frame() %>%
        select(-geometry)
    })
    
  })
  
}







