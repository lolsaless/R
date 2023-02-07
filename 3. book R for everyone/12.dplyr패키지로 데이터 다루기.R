library(tidyverse)

diamonds

diamonds %>% select(-cut)
diamonds %>% select(where(is.numeric))

theCols <- c('carat', 'price')
theCols

diamonds %>% select(.dots = theCols)
diamonds %>% select(one_of('carat', 'price'))
