library(plotly)
library(dplyr)
library(maps)

# map data
county_df <- map_data("county")
state_df <- map_data("state")

county_df$subregion <- gsub(" ", "", county_df$subregion)

#election data
df <- read.csv("https://raw.githubusercontent.com/bcdunbar/datasets/master/votes.csv")
df <- subset(df, select = c(Obama, Romney, area_name))

df$area_name <- tolower(df$area_name) 
df$area_name <- gsub(" county", "", df$area_name)
df$area_name <- gsub(" ", "", df$area_name)
df$area_name <- gsub("[.]", "", df$area_name)

df$Obama <- df$Obama*100
df$Romney <- df$Romney*100

for (i in 1:length(df[,1])) {
    if (df$Obama[i] > df$Romney[i]) {
        df$Percent[i] = df$Obama[i]
    } else {
        df$Percent[i] = -df$Romney[i]
    }
}

names(df) <- c("Obama", "Romney", "subregion", "Percent")

# join data
US <- inner_join(county_df, df, by = "subregion")
US <- US[!duplicated(US$order), ]

# colorramp
blue <- colorRampPalette(c("navy","royalblue","lightskyblue"))(200)                      
red <- colorRampPalette(c("mistyrose", "red2","darkred"))(200)

#plot
p <- ggplot(US, aes(long, lat, group = group)) +
    geom_polygon(aes(fill = Percent),
                 colour = alpha("white", 1/2), size = 0.05)  +
    geom_polygon(data = state_df, colour = "white", fill = NA) +
    ggtitle("2012 US Election") +
    scale_fill_gradientn(colours=c(blue,"white", red))  +
    theme_void()

fig <- ggplotly(p)

fig
