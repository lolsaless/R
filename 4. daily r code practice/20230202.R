z <- c(1,2,NA,4,5,NA,9)

is.na(z)
sum(is.na(z))


z %>% is.na %>% sum

z %>% mean()

z %>% mean(na.rm = TRUE)

mpg
library(tidyverse)

mpg
is.data.frame(mpg)
view(mpg)

nrow(mpg)
ncol(mpg)

dim(mpg)

names(mpg)
head(mpg)
head(mpg, 2)


names(mpg)[1:2]
names(mpg)[1,2] #이건 안됨 왜그럴까?

rownames(mpg)
colnames(mpg)
colnames(mpg)[2]

rownames(mpg) <- c(2:235)

a <- mpg

rownames(a) <- c(2:235)


rownames(a) <- NULL
rownames(a)[1] <- "one"
rownames(a)[1]
rownames(a) <- NULL
rownames(a)

head(mpg)[2]
head(mpg)[1]
head(mpg, 1)
head(mpg,1)[1]
head(mpg,3)[2:4]
head(mpg,3)[2:4][1]


