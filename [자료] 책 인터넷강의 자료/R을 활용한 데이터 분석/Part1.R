library(tidyverse)

head(mpg)
mean(mpg$hwy)
max(mpg$hwy)
hist(mpg$hwy)

a <- 1
b <- 2
c <- 3

a + b
a+b+c
4/b
5*b

d <- c(1:5)
e <- c(1:5)
f <- seq(1, 5)
g <- seq(1, 10, by = 2)

paste(a,b,c,d)
