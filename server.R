#server.R for the Amazing Race Map App 

#Author: Jonathan Fivelsdal

library(shiny)

library(leaflet)

amRaceDataCoords <- read.csv(
          file = "AmazingRace - LongitudeAndLatitudeList.csv",
          stringsAsFactors = FALSE)


amRaceContestants <- read.csv(
                    file = "AmazingRaceContestants.csv",
                    stringsAsFactors = FALSE)


shinyServer( function(input,output,session){
  
  amMap = leaflet() %>% addTiles()
  
  seasonWinners <- c("Rob Frisbee & Brennan Swain",
                     "Chris Luca & Alex Boylan",
                     "Flo Pesenti & Zach Behr",
                     "Reichen Lehmkuhl & Chip Arndt",
                     "Chip & Kim McAllister","Freddy Holliday & Kendra Bentley",
                     "Uchenna & Joyce Agu","Nick, Alex, Megan, and Tommy Linz",
                     "B.J. Averell & Tyler MacNiven","   Tyler Denk & James Branaman",
                     "Eric Sanchez & Danielle Turner","TK Erwin & Rachel Rosales",
                     "Nick & Emily Starr Spangler","Tamara Tien-Jan Tammy & Victor Jih",
                     "Meghan Rickey & Cheyne Whitney","Daniel Dan & Jordan Pious",
                     "Natalie Nat Strand & Katherine Kat Chang",
                     "LaKisha Kisha Hoffman & Jennifer Jen Hoffman",
                     "Ernie Halvorsen & Cindy Chiang","Rachel Brown & Dave Brown, Jr.",
                     "Josh Kilmer-Purcell & Brent Ridge","Bates Battaglia & Anthony Battaglia",
                     "Jason Case & Amy Diaz","Dave & Connor O'Leary",
                     "Amy DeJong & Maya Warren")
  
  output$winnerText = renderText({paste(seasonWinners[as.numeric(input$seasonSL)],
                                "were the winners in season",
                                input$seasonSL)})
  
  #Changes the choices for the Leg menu based on the season number
  
  observe( { updateSelectInput(session, inputId = "legSL", label = "Leg Name",
                    choices = unique(
                      amRaceDataCoords[which(amRaceDataCoords$Season == input$seasonSL),
                                       "Leg"])) })
  
  output$teamTable <- renderDataTable(amRaceContestants[which(
                      amRaceContestants$Season == input$seasonSL),c("Team","Relationship")])
 
  
 markerProp <- reactive({ 
   
   #If neither the Season Map or Season Leg tab is chosen, create 
   # these default values for latitude and longitude
   
   if( !( input$amazingRaceTabs %in% c("mapTabSeason","mapTabLegSeason") ) )
   {
     longitude <- 0;latitude <- 0
   }
   else if (input$amazingRaceTabs == "mapTabSeason")
  {
   longitude <- amRaceDataCoords[which(amRaceDataCoords$Season == input$Season),]$Longitude
   
   latitude <- amRaceDataCoords[which(amRaceDataCoords$Season == input$Season),]$Latitude
   
   }
   else if(input$amazingRaceTabs == "mapTabLegSeason")
   {
    longitude <- amRaceDataCoords[which(amRaceDataCoords$Season == input$seasonSL
                                        & amRaceDataCoords$Leg == input$legSL),]$Longitude
  
    latitude <- amRaceDataCoords[which(amRaceDataCoords$Season == input$seasonSL
                                       & amRaceDataCoords$Leg == input$legSL),]$Latitude
    }

   if(input$markerType == "Pin")
     
     #Use the addMarkers function to create pins
     
     addMarkers(amMap,lng = longitude,
                lat = latitude) 
  
   else if(input$markerType == "Circle")
     
      #Use the addCircleMarkers to create circles
     
     addCircleMarkers(amMap,lng = longitude,
                      lat = latitude,color = input$colorChoice) 
   
   else if(input$markerType == "Path")

     addPolylines(amMap,longitude,latitude,color = input$colorChoice)
 
   }
 ) #end of reactive function
 
 
 output$raceMap = renderLeaflet(markerProp())
 
} #closing bracket for the main function defined in the shinyServer function
) #end of shinyServer function                                                                                                                                                                                                                                                                                                

#Use leafletOutput() to create a UI element, and renderLeaflet() to render the map widget


