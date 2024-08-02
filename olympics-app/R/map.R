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
          
        )
      )
    )
  )
  
}




#Map Server ----------------------------------------------------

map_server <- function(id, parent, label = "map_server") {
  
  moduleServer(id, function(input, output, session) {
    

    
  })
  
}







