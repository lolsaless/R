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
x %>% map_dbl(2)

