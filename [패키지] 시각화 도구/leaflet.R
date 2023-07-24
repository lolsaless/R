install.packages("leaflet")
library(leaflet)

leaflet() %>%
    addTiles() %>%
    setView(lng = -3.7, lat = 40.4, zoom = 5) 

leaflet() %>%
    addTiles() %>%
    setView(lng = -3.7, lat = 40.4, zoom = 5) %>%
    addMarkers(lng = -3.7, lat = 40.4) 

library(leaflet)

leaflet() %>%
    addTiles() %>%
    setView(lng = -3.7, lat = 40.4, zoom = 5) %>%
    addMarkers(data = data.frame(lng = c(-3.7, -8, -4.2), lat = c(40.4, 43.1, 41.4))) 


library(leaflet)

# Data
df <- data.frame(lng = c(12.5, 14.3, 11.234),
                 lat = c(42, 41, 43.84),
                 group = c("A", "B", "A"))

# Icons
icons_list <- icons(iconUrl = ifelse(df$group == "A", 
                                     'https://raw.githubusercontent.com/R-CoderDotCom/samples/main/marker.png',
                                     ifelse(df$group == "B", "https://raw.githubusercontent.com/R-CoderDotCom/chinchet/main/inst/red.png", NA)),
                    iconWidth = c(50, 90, 40), iconHeight = c(50, 90, 40))

leaflet() %>%
    addTiles() %>%
    setView(lng = 12.43, lat = 42.98, zoom = 6) %>%
    addMarkers(data = df, icon = icons_list) 


library(leaflet)

circles <- data.frame(lng = c(23.59, 34.95, 17.47),
                      lat = c(-3.53, -6.32, -12.24))

leaflet() %>%
    addTiles() %>%
    addCircleMarkers(data = circles, color = "red") 


library(leaflet)
library(sf)

# Read a Geojson or shapefile
data_map <- read_sf("https://raw.githubusercontent.com/R-CoderDotCom/data/main/sample_geojson.geojson")

# Transform to leaflet projection if needed
data_map <- st_transform(data_map, crs = '+proj=longlat +datum=WGS84')

leaflet() %>%
    addTiles() %>%
    setView(lng = -0.49, lat = 38.34, zoom = 14) %>%
    addPolygons(data = data_map, color = "blue", stroke = 1, opacity = 0.8) 

library(leaflet)

circles <- data.frame(lng = c(-73.58, -73.46), lat = c(45.5, 45.55))

leaflet() %>%
    addTiles() %>%
    setView(lng = -73.53, lat = 45.5, zoom = 12) %>%
    addCircles(data = circles, radius = 2000,
               popup = paste0("Title", "<hr>", "Text 1", "<br>", "Text 2")) %>%
    addCircleMarkers(data = circles,
                     popup = c("A", "B")) 

library(leaflet)

circles <- data.frame(lng = c(-3.7, -8, -4.2),
                      lat = c(40.4, 43.1, 41.4),
                      values = c(10, 20, 30))

# Continuous palette
# pal <- colorNumeric(palette = "viridis", domain = circles$values)

# Discrete palette
pal <- colorFactor("viridis", levels = circles$values)

leaflet() %>%
    addTiles() %>%
    setView(lng = -3.7, lat = 40.4, zoom = 5) %>%
    addCircleMarkers(data = circles, color = ~pal(values)) %>%
    addLegend(data = circles,
              position = "bottomright",
              pal = pal, values = ~values,
              title = "Legend",
              opacity = 1) 





