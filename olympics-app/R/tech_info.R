#Info UI ---------------------------------------------------------------

info_ui <- function(id, label = "info_ui") {
  ns <- NS(id)
  tagList(
    fluidRow(
      h2("App info"),
      HTML("This simple R Shiny app pulls data from a free Olympics data API by 
           <a href='https://docs.apis.codante.io/olympic-games-english' target='_blank'>codante</a>.
           <br>
           <br>
           'Per capita' calculations are performed using the `countrypops` data frame from the `gt`
           R package.
           <br>
           <br>
           The world map is created using the `rnaturalearth`, `rnaturalearthdata`, `ggplot2`, and `plotly`
           packages.
           <br>
           <br>
           Find the code for the app <a href='https://github.com/melbather/2024-olympics-data'>here</a>."),
      h3("About the author"),
      HTML("This app was made by Melissa, a kiwi statistician/analyst living in Vancouver, BC, Canada. For more info, visit
           <a href='https://melbather.github.io' target='_blank'>melbather.github.io</a>.")
    )
  )
}




#Info Server ----------------------------------------------------

info_server <- function(id, parent, label = "info_server") {
  
  moduleServer(id, function(input, output, session) {
   
  })
  
}







