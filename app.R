#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

trafficsig <- read.csv("traffic_lights.csv")
trafficsig <- mutate(trafficsig, MainRoads = NA)

## Getting some specific main roads categorized 

trafficsig$MainRoads[11:22] <- "CommAve"
trafficsig$MainRoads[119:127] <- "Beacon"
trafficsig$MainRoads[500:506] <- "Boylston"
trafficsig$MainRoads[519:526] <- "Cambridge"

# State boundaries from the maps package. 
bounds <- map('state', c('Massachusetts'), fill=TRUE, plot=FALSE)
# icons
icons <- awesomeIcons(
    icon = 'disc',
    iconColor = 'yellow',
    library = 'ion', # Options are 'glyphicon', 'fa', 'ion'.
    markerColor = 'blue',
    squareMarker = TRUE, 
)
icons1 <- awesomeIcons(
    icon = 'disc',
    iconColor = 'blue',
    library = 'ion', # Options are 'glyphicon', 'fa', 'ion'.
    markerColor = 'black',
    squareMarker = TRUE, 
)

icons2 <- awesomeIcons(
    icon = 'disc',
    iconColor = 'red',
    library = 'ion', # Options are 'glyphicon', 'fa', 'ion'.
    markerColor = 'yellow',
    squareMarker = TRUE, 
)
 

ui <- fluidPage(

    titlePanel("City of Boston traffic signals."), 
    
    #Select input for Dist of traffic signals 
    sidebarPanel(
        selectInput("dist", "Highlight Community Traffic Signals", choices = unique(trafficsig$Dist)), 
        selectInput('road', "Highlight Specific Main Streets", choices = unique(trafficsig$MainRoads))
    ),
    
    mainPanel(
        leafletOutput("MyMap"), 
        width = 12
    )
)
 


server <- function(input, output) {

    output$MyMap <- renderLeaflet({
        trafficsig1 <- trafficsig %>% filter(Dist == input$dist)
        trafficsig2 <- trafficsig %>% filter(MainRoads == input$road)
        leaflet(data = trafficsig) %>%
        setView(-71.05716, 42.35209, zoom = 11) %>%
        addProviderTiles("CartoDB.Positron", group = "Map") %>%
        addProviderTiles("Esri.WorldImagery", group = "Satellite")%>% 
        addProviderTiles("Esri.WorldShadedRelief", group = "Relief")%>%
        addAwesomeMarkers(~X, ~Y, label = ~Location, group = "Traffic Signals", icon=icons) %>%
        addAwesomeMarkers(~trafficsig1$X, ~trafficsig1$Y, label = ~Location, group = "Traffic Signals", icon=icons1) %>% 
        addAwesomeMarkers(~trafficsig2$X, ~trafficsig2$Y, label = ~Location, group = "Traffic Signals", icon=icons2) %>% 
        addPolygons(data=bounds, group="States", weight=2, fillOpacity = 0) %>%
        addScaleBar(position = "bottomleft") %>%
        addLayersControl(
            baseGroups = c("Map", "Satellite", "Relief"),
            overlayGroups = c("States"),
            options = layersControlOptions(collapsed = FALSE)
        )
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
