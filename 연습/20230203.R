library(tidyverse)

listmpg <- as.list(mpg)

view(listmpg)
listmpg


list(1,2,3)
list(c(1,2,3),c(2,3,4),c(4,5,6))


thempg <- mpg[1:10,1:4]
thempg
thempg

list3 <- list(c(1:3), 3:7)
list3
list4 <- list(thempg, 1:10, list3)
list4
names(list4)

names(list4) <-c("data.frame", "vector", "list")
list4
list4[2]
list6 <- list(thedataframe = thempg, thevector = 1:10, thelist = list3)
list6
emptylist <- vector(mode = "list", length = 4)
emptylist2 <- data.frame(mode = "list", lenght = 4)
emptylist2

?vector

test <- vector(mode = "expression", length = 2)
test
test1 <- vector(mode = "logical", length = 3)
test1
test2 <- vector(mode = "list", length = 2)
test2

list4
list4[[2]]
list4[2]
class(list4[[2]])
class(list4[2])

list4[[1]]$manufacturer
list4[[1]][,3]
list4[[1]][,"year", drop = FALSE]
?list

list4[[4]] <- 2
list4

a <- c(1:10)
b <- c(11:20)
a
b
a+b


#matrix

A <- matrix(1:10, nrow = 5)
A
B <- matrix(21:30, nrow = 5)
B
C <- matrix(21:40, nrow = 2)
C

A + B
A == B
A
t(B)

A * B
A %*% t(B)
t(B)
A

a <- matrix(1:4, nrow = 2)
a
b <- matrix(2:5, nrow = 2)
b
a %*% b
a*b
a
b

A
t(B)


colnames(A) <- c("left", "Right")
rownames(A) <- c("1st", "2nd", "3rd", "4th", "5th")
A
LETTERS[1:3]

theArray <- array(1:12, dim = c(2,3,4))
theArray
