library(tidyverse)

diamonds

diamonds %>% select(-cut)
diamonds %>% select(where(is.numeric))

theCols <- c('carat', 'price')
theCols

diamonds %>% select(.dots = theCols)
diamonds %>% select(one_of('carat', 'price'))
diamonds %>% select(c('carat', 'price'))
diamonds[, c('carat', 'price')]

diamonds %>% select(starts_with("c"))
diamonds %>% select(ends_with("t"))
diamonds %>% select(contains('i'))
