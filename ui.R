#ui.R file for Amazing Race Map App

#Author: Jonathan Fivelsdal

library(leaflet)
library(shiny)

#```{r, echo = FALSE}

#shinyApp(

shinyUI( fluidPage(
 
  titlePanel("Amazing Race Map"),
  
  sidebarLayout( sidebarPanel = sidebarPanel(
    
    #Show the Season Number slider only for the Season Map and Winner Tab
    
    conditionalPanel(condition = "(input.amazingRaceTabs != 'mapTabLegSeason'
                     & input.amazingRaceTabs != 'teamSeason' & 
                     input.amazingRaceTabs != 'winTab') ",
      sliderInput("Season","Season Number",min = 1, max = 25, value = 12,step = 1)
      ),
   
    #Show the menu selectors for Season and Leg for the Season and Leg Map tab and
    # the locations tab
    
    conditionalPanel(condition = "(input.amazingRaceTabs == 'mapTabLegSeason'
                    || input.amazingRaceTabs == 'teamSeason' ||
                      input.amazingRaceTabs == 'winTab')" , 
      selectInput(inputId = "seasonSL",label = "Season Number", choices = 1:25)),
      
    conditionalPanel(condition = "input.amazingRaceTabs == 'mapTabLegSeason'",
      selectInput(inputId = "legSL", label = "Leg Number",choices = "")
      ),
    
    #Only show the marker types for the Season Map or the Season and Location Map tabs
    
    conditionalPanel(condition = "input.amazingRaceTabs == 'mapTabSeason'|| 
                      input.amazingRaceTabs == 'mapTabLegSeason'",
      selectInput(inputId = "markerType",
                  label = "Marker Type",choices = c("Pin","Circle","Path"))),
      
      #Had to put the single quotes in front of Pin in order to have the conditional panel recognize it
      conditionalPanel(condition = "input.markerType != 'Pin' & (input.amazingRaceTabs == 'mapTabSeason'
                       || input.amazingRaceTabs == 'mapTabLegSeason')",
                       
      radioButtons(inputId = "colorChoice",label = "Marker Color Selection",
                   choices = c("Red" = "red","Orange" = "orange","Yellow" = "yellow",
                               "Green" = "green","Blue" = "blue",
                               "Purple" = "purple","Black" = "black" ))
      
      ) # End of conditional panel for the marker type
      ), #End of sliderPanel
  
 mainPanel = mainPanel(
  
  tabsetPanel(id = "amazingRaceTabs", 
   
  tabPanel("Season Map",value = "mapTabSeason"),
  
  tabPanel("Season and Leg Map",value = "mapTabLegSeason"),
  
  tabPanel("Teams By Season",dataTableOutput("teamTable"),value = "teamSeason"),
  
  tabPanel("Winners",textOutput("winnerText"),value = "winTab")
    
  ), #ends the tabset panel
  
  #If the winner tab is not selected, show the race map
  conditionalPanel(condition = "input.amazingRaceTabs == 'mapTabSeason' || 
                   input.amazingRaceTabs == 'mapTabLegSeason' ",
                   leafletOutput("raceMap"))
  
) #ends the main panel function
 
) #ends the sidebarLayout function

) #closes of fluidPage

) #closes shinyUI

