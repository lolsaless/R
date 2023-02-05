library(tidyverse)
ifelse(!require(nycflights13), install.packages("nycflights13"), library(nycflights13))
flights |>
  filter(arr_delay > 120)
flights %>% 
  filter(arr_delay > 120)

flights %>% 
  filter(month == 1 & day == 1)
