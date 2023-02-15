library(tidyverse)
colorURL <- "http://www.jaredlander.com/data/DiamondColors.csv"
diamondColors <- read_csv(colorURL, show_col_types = FALSE)
