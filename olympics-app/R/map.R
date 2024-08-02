#Map UI ---------------------------------------------------------------

map_ui <- function(id, label = "map_ui") {
  ns <- NS(id)
  tagList(
    fluidRow(
      #Sidebar 
      sidebarLayout(
        sidebarPanel(
          
          
          
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







