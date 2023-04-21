df <- tibble(
    a = rnorm(10),
    b = rnorm(10),
    c = rnorm(10),
    d = rnorm(10)
)

temp <- c()
for (i in 1:ncol(df)) {
    print(i)
    temp[i] <- mean(df[[i]])
    
}
temp

map_dbl(df, mean)
map_dbl(df, median)
map_dbl(df, sd)

map_dbl(df, mean, trim = 0.5)

models <- mtcars %>% 
    split(.$cyl) %>% 
    map(function(df) lm(mpg ~ wt, data = df))

models <- mtcars %>% 
    split(.$cyl) %>% 
    map(~lm(mpg ~ wt, data = .))

models %>% 
    map(summary) %>% 
    map_dbl(~.$r.squared)

models %>% 
    map(summary) %>% 
    map_dbl("r.squared")


#정수형을 사용하여 위치로 요소를 선택할 수 있다.
x <- list(list(1,23,3), list(4,56,6), list(7,78,9))
library(tidyverse)
x %>% map_dbl(2, mean)


x1 <- list(
    c(0.27, 0.37, 0.57, 0.91, 0.20),
    c(0.90, 0.94, 0.66, 0.63, 0.06),
    c(0.21, 0.18, 0.69, 0.38, 0.77)
)

x2 <- list(
    c(0.50, 0.72, 0.99, 0.38, 0.78),
    c(0.93, 0.21, 0.65, 0.13, 0.27),
    c(0.39, 0.01, 0.38, 0.87, 0.34)
)


threshold <- function(x, cutoff = 0.8) x[x > cutoff]
x1 %>% sapply(threshold) %>% str()

safelog <- safely(log)

str(safelog(10))

safelog
log
log(10)
str(log(10))

str(safely(log(10)))

a <- safely(log)

a(10)
str(a)
str(a(10))


x <- list(1, 10, "a")
y <- x %>% map(safely(log))
y
str(y)

y <- y %>% transpose()
str(y)

is_ok <- y$error %>% map_lgl(is_null)
is_ok

x[!is_ok]
