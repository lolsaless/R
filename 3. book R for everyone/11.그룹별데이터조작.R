theMatrix <- matrix(1:9, nrow = 3)
theMatrix

apply(theMatrix, 1, sum)
apply(theMatrix, 2, sum)

rowSums(theMatrix)
colSums(theMatrix)
theMatrix[2,1] <- NA
theMatrix
apply(theMatrix, 1, sum)
apply(theMatrix, 1, sum, na.rm = TRUE)

#lapply, sapply
theList <- list(A = matrix(1:9, 3), B = 1:5, C = matrix(1:4, 2), D = 2)
lapply(theList, sum)
sapply(theList, sum)

1:5
15:1

firstList <- list(A = matrix(1:16, 4), B = matrix(1:16, 2), C = 1:5)
secondList <- list(A = matrix(1:16, 4), B = matrix(1:16, 8), c = 15:1)

mapply(identical, firstList, secondList)
?identical
identical(1, 2)
identical(1,1)

simpFunc <- function(x,y){
  NROW(x) + NROW(y)
}

mapply(simpFunc, firstList, secondList)

firstList
secondList
NROW(1:5)

library(tidyverse)
aggregate(price ~ cut, diamonds, mean) %>% 
  arrange(desc(price))

diamonds %>% group_by(cut) %>% 
  summarise(mean_price = mean(price)) %>% 
  arrange(desc(mean_price))

diamonds %>% group_by(cut, color) %>% 
  summarise(mean_price = mean(price)) %>% 
  arrange(color)

a <- aggregate(price ~ cut + color, diamonds, mean)
b <- aggregate(price ~ cut + color, diamonds, max)
aggregate(cbind(price, carat) ~ cut + color, diamonds, mean)

cbind(a, b)
rbind(a, b)
