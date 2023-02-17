library(tidyverse)
colorURL <- "http://www.jaredlander.com/data/DiamondColors.csv"
diamondColors <- read_csv(colorURL, show_col_types = FALSE)

diamondColors
data("diamonds", package = "ggplot2")

unique(diamonds$color)

left_join(diamonds, diamondColors, by = c('color' = 'Color')) %>% 
  select(carat, color, price, Description, Details)

diamondColors %>% mutate(color = Color)

rename(diamondColors, color = Color)
