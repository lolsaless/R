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

diamonds %>% filter(cut == "Ideal")

theCol <- "ABCD"
as.name(theCol)
as.name(diamonds)
as.vector(diamonds)
is.data.frame(diamonds)
as.data.frame(diamonds)
?as.name

diamonds %>% slice(1:5, 8, 15:20)

diamonds %>% mutate(price/carat,
                    .before = 1)
diamonds %>% mutate(ratio = price/carat) %>% select(ratio)
diamonds %>% select(price, carat) %>% mutate(ratio = price/carat)

topN <- function(x, N = 5) {
  x %>% arrange(desc(price)) %>% head(N)
}

diamonds %>% group_by(cut) %>% do(topN(., N = 10))
