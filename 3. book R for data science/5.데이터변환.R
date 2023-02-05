library(tidyverse)
ifelse(!require(nycflights13), install.packages("nycflights13"), library(nycflights13))
flights |>
  filter(arr_delay > 120)
flights %>% 
  filter(arr_delay > 120)

flights %>% 
  filter(month == 1 & day == 1)

flights %>% 
  filter(month == 1 | month == 2) %>% 
  tail()

flights %>% 
  filter(month %in% c(1,2)) %>% 
  tail()

jan1 <- flights %>%
  filter(month == 1 & day == 1)

flights %>% 
  arrange(year, month, day, dep_time)

flights %>% 
  arrange(desc(dep_delay))

flights %>% 
  filter(dep_delay <= 10 & dep_delay >= -10) %>% 
  arrange(desc(arr_delay))

flights %>% 
  filter(month = 1)

flights %>% 
  filter(month == 1|2)

flights %>% 
  mutate(gain = dep_delay - arr_delay,
         speed = distance / air_time * 60,
         .before = 1)
?mutate


