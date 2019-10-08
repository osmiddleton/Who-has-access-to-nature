
# Code for producing a shiny app

# Libraries
library(shiny)
library(leaflet)

# Define UI for app that draws a histogram ----
# What the app looks like...
ui <- fluidPage(
  leafletOutput("mymap"),
  p(),
  selectInput(inputId = "Species", "Choose your species", c("Butterfly", "Dog")),
  textOutput("text")
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {
  output$mymap <- renderLeaflet ({
    leaflet() %>%
      addTiles() %>% 
        setView(lat = 54.6, lng = -2.34, zoom = 5)
  })
  
  observeEvent(input$Species,{
  output$text <- renderText({
  paste0("This is a ", input$Species)
  })
  })
    }

shinyApp(ui, server)
