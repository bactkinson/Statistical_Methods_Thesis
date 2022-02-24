require(sf)
require(tmap)
require(tmaptools)
require(tidyverse)

key_conversion <- function(houston_polygons){
  houston_polygons$Name[houston_polygons$Name == "510800"] <- "Memorial Park"
  houston_polygons$Name[houston_polygons$Name == "3308"] <- "South Beltway Central"
  houston_polygons$Name[houston_polygons$Name == "520300"] <- "North Spring Branch"
  houston_polygons$Name[houston_polygons$Name == "520200"] <- "South Spring Branch"
  houston_polygons$Name[houston_polygons$Name == "411200"] <- "North River Oaks"
  houston_polygons$Name[houston_polygons$Name == "411400"] <- "South River Oaks"
  houston_polygons$Name[houston_polygons$Name == "510200"] <- "Washington Corridor"
  houston_polygons$Name[houston_polygons$Name == "412000"] <- "North Rice"
  houston_polygons$Name[houston_polygons$Name == "412200"] <- "South Rice"
  houston_polygons$Name[houston_polygons$Name == "511500"] <- "North Heights"
  houston_polygons$Name[houston_polygons$Name == "432400"] <- "Westchase"
  houston_polygons$Name[houston_polygons$Name == "432901"] <- "Sharpstown North"
  houston_polygons$Name[houston_polygons$Name == "432802"] <- "Sharpstown"
  houston_polygons$Name[houston_polygons$Name == "433300"] <- "Sharpstown South"
  houston_polygons$Name[houston_polygons$Name == "422701"] <- "Bayland Park"
  houston_polygons$Name[houston_polygons$Name == "233600"] <- "Clinton"
  houston_polygons$Name[houston_polygons$Name == "233701"] <- "West Galena Park"
  houston_polygons$Name[houston_polygons$Name == "233702"] <- "East Galena Park"
  houston_polygons$Name[houston_polygons$Name == "324200"] <- "Manchester"
  houston_polygons$Name[houston_polygons$Name == "311400"] <- "Harrisburg"
  houston_polygons$Name[houston_polygons$Name == "320200"] <- "Milby Park"
  houston_polygons$Name[houston_polygons$Name == "210800"] <- "West Eastex"
  houston_polygons$Name[houston_polygons$Name == "520500"] <- "Cypress"
  houston_polygons$Name[houston_polygons$Name == "530400"] <- "Independence Heights"
  houston_polygons$Name[houston_polygons$Name == "211000"] <- "Kashmere"
  houston_polygons$Name[houston_polygons$Name == "211900"] <- "East Fifth Ward"
  houston_polygons$Name[houston_polygons$Name == "320500"] <- "Pasadena Northwest"
  houston_polygons$Name[houston_polygons$Name == "342700"] <- "Deer Park"
  houston_polygons$Name[houston_polygons$Name == "253600"] <- "Baytown North"
  houston_polygons$Name[houston_polygons$Name == "254500"] <- "Baytown West"
  houston_polygons$Name[houston_polygons$Name == "550100"] <- "Aldine Northwest"
  houston_polygons$Name[houston_polygons$Name == "240100"] <- "Aldine Northeast"
  houston_polygons$Name[houston_polygons$Name == "222600"] <- "Aldine Southeast"
  houston_polygons$Name[houston_polygons$Name == "421201"] <- "Westpark West"
  houston_polygons$Name[houston_polygons$Name == "421102"] <- "Westpark East"
  
  return(houston_polygons)
}

houston_lays <- st_layers(paste0(getwd(),"/mobile_polygons_20m_buffer.kml"))

houston_polygons <- st_read(paste0(getwd(),"/mobile_polygons_20m_buffer.kml"),layer = houston_lays$name[1])

ct_num <- 1

houston_polygons <- cbind(houston_polygons,"ct_num" = as.factor(rep(ct_num,nrow(houston_polygons))))


for(k in 2:length(houston_lays)){
  ct_num <- k
  
  temp_polygons <- st_read(paste0(getwd(),"/mobile_polygons_20m_buffer.kml"),layer = houston_lays$name[k])
  
  temp_polygons <- cbind(temp_polygons,"ct_num" = as.factor(rep(ct_num,nrow(temp_polygons))))
  
  houston_polygons <- rbind(houston_polygons,temp_polygons)
}

houston_polygons <- key_conversion(houston_polygons)

## Creating map for Chapter 2 of thesis.

tmap_mode("plot")

ch_3_polygons <- houston_polygons %>%
  filter(Name %in% c("North Spring Branch", "South Spring Branch", "Memorial Park",
                     "Washington Corridor", "North River Oaks", "South River Oaks",
                     "West Eastex", "North Heights","Westchase",
                     "Sharpstown","Sharpstown South","Sharpstown North","Bayland Park",
                     "South Beltway Central","North Rice","South Rice","Clinton",
                     "West Galena Park","East Galena Park","Manchester","Harrisburg","Milby Park"))

# require(tmaptools)
# 
# osm_polygons <- read_osm(ch_3_polygons)
# 
# poly_map <- 
#   tm_shape(osm_polygons) + 
#   tm_text("Name",col = "black", size = 1.2)
#   
# poly_map

require(leafem)
require(leaflet)
leaflet(ch_3_polygons) %>%
  addProviderTiles("OpenStreetMap") %>%
  addFeatures(., weight = 1, color = "red") %>%
  addStaticLabels(.,label = ch_3_polygons$Name, style = list("color" = "black","font-weight" = "bold","font-size"="12px"))


