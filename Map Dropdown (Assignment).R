#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(ggmap)
library(maptools)
library(maps)
library(mapproj)

map_proj <- c("cylindrical", "mercator", "sinusoidal", "gnomonic")
mp1 <- ggplot(mapWorld, aes(x=long, y=lat, group=group))+
    geom_polygon(fill="white", color="black") +
    coord_map(xlim=c(-180,180), ylim=c(-60, 90))

ui <- fluidPage(

    selectInput("projection", "Type of Map Projection", map_proj, multiple = F, selected = NULL),
    plotOutput("projection")
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    
    output$projection <- renderPlot(
        
        mp1 + coord_map(input$projection ,xlim=c(-180,180), ylim=c(-60, 90))
    )

    
}

# Run the application 
shinyApp(ui = ui, server = server)
