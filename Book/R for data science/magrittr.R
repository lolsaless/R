library(magrittr)

foo_foo <- little_bunny()


rnorm(100) %>% 
  matrix(ncol = 2) %>% 
  plot() %>% 
  str()

rnorm(100) %>% 
  matrix(ncol = 2) %T>%
  plot() %>% 
  str()
 