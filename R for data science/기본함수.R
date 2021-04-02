library(dplyr)
x <- c(1,4,6,8,9)

y <- x %>% replace(c(2,4), c(32,44))
y

w <- append(x,y)
w
z <- append(x,y, after = 2)
z

c(1,2) + c(4,5)
vector <- -5:5
vector

q <- seq(1,5, by= 0.5)
qq <- seq(100)
qq
x <- sort(sample(1:99, 10))
x
y <- sort(sample(3:60, 10))
y

a <- append(x,y)
a

#합집합
union(x,y)
#교집합
intersect(x,y)
#차집합
setdiff(x,y)
#x,y가 같은가
setequal(x,y)
#x가 y에 포함되는가
is.element(18, x)

x <- rep(c('a', 'b', 'c'), 4)
x

rep(c('a','b'), 5)

unique(x)
match(x, 'a')
?match

xx <- c('a', 'b', 'c', 'd', 'e')
k = paste(xx[1], xx[2], x[1])
k

paste(xx, sep = '1234')
paste(xx, collapse = '%%')
paste('I lvoeo ', 'sdfsf ', 'sgsdfsdf ', sep = '$$$')

paste(xx, collapse = "")
paste(xx, collapse = "    ")
substring('qqwerqwesda', 2:3)

x <- 'hello'
substring(x, c(1,2),c(3,4))

substring(x, 1:2, 3:4)
substring(x, 1:5, 1:5)
?filter

filter(x,contains('h'))

vec1 <- c(1,2,3)
vec2 <- c(4,5,6)
vec3 <- c(7,8,9)

a <- rbind(vec1, vec2, vec3)
a
apply(a, 1, max)
apply(a, 2, max)
apply(a, 1, min)

colnames(a) <- c('A', 'B', 'C')
a
x1 <- matrix(1:10, nrow = 2)
x1
x2 <- matrix(1:10, ncol = 2)
x2

x1
x1*3
x1*c(10, 20)

x <- matrix(sample(1:100, 12),
            nrow = 3,
            dimnames = list(c('R1', 'R2', 'R3'), c(1,2,3,4)))
x
x[2]
x[3]
x[5]


x <- matrix(1:6, nrow=2, dimnames = list(c(5,6),c(1,2,3)))
x[1,1]
x[2,3]


x <- matrix(5:10, nrow = 2)
x

mean(x[2,])
apply(x, 1, sum)
apply(x,2,sum)


x <- array(1:24, dim = c(2,4,3), dimnames = list(c(1:2, 1:3)))
x

x <- 20:30
which(abs(x-5) == max(abs(x-5)))
abs(x-5)
x-5
min(abs(x-5))
max(abs(x-5))

rm(list=ls())


for (i in 1:10) {
  assign(paste("x", i, sep = ""),i)
}
x1
x2

for(i in seq(10)){
  
  assign(paste0('제',i,'회', sep = ""),i)
  
}

x9

example(cat)
example(matrix)
ls.str()
rm(list = ls())
example(rm)
rm()

gl(3,3,10)

x <- c(1:12)
x
X <- matrix(x, 3,4)
X
a <- matrix(1:20, 5,5)

b <- matrix(40:59, 5,5)
b
rbind(a,b)
cbind(a,b)

a[1,]
rbind(a[1,])
cbind(a[1,])
det(a)
det(X)
X
norm(X)
diag(X)

mpg
library(ggplot2)
mpg
mpg['model']
mpg[['model']]
mpg[['model']]
mpg['model']
