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

is.data.frame(mpg)

mpg
print(mpg, n= 20)

x <- mpg$manufacturer
y <- mpg$model
z <- mpg$hwy

thempg <- data.frame(x, y, z)
thempg <- data.frame("제조사" = x, 모델 = y, 연비 = z)
head(mpg)
head(thempg)
view(thempg)

dim(thempg)
names(thempg)
names(thempg)[3]
row.names(thempg)

class(thempg)
is.data.frame(thempg)

class(thempg$연비)
class(thempg$제조사)
class(thempg$모델)

is.integer(thempg$연비)
is.integer(thempg[,3])

thempg[3, 2:3]
thempg[3]
thempg

head(thempg)

thempg[3,3]
thempg[3,2:3]
thempg[1,1]
thempg[1,6]
thempg[6,1:3]
thempg[1:2,2:3]

