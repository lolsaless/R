library(nycflights13)
library(tidyverse)

str(flights)
dim(flights)

jan1 <- flights %>% filter(., month == 1, day == 1)
dec25 <- flights %>% filter(., month == 12, day == 25)
nov_dec <- filter(flights, month %in% c(11,12))
delay_1 <- filter(flights, !(arr_delay > 120 | dep_delay > 120))
delay_2 <- filter(flights, !(arr_delay < 120 | dep_delay < 120))
delay_3 <- filter(flights, arr_delay <= 120, dep_delay <= 120)
delay_4 <- filter(flights, arr_delay <= 120 & dep_delay <= 120)

flights %>% select(carrier) %>% table()

#두시간 이상 도착 지연
Q1a <- filter(flights, dep_delay >= 120)
Q1b <- filter(flights, dest %in% c('IAH', 'HOU'))
Q1c <- filter(flights, carrier %in% c('UA', 'AA', 'DL'))
Q1d <- filter(flights, month %in% c(7,8,9))
Q1dd <- filter(flights, between(month, 7, 9))
Q1e <- filter(flights, dep_delay <= 0 & arr_delay > 120)
Q1f <- filter(flights, dep_delay >= 60, dep_delay - arr_delay >= 30)

filter(flights, dep_time == 2400 | dep_time <= 600)
filter(flights, is.na(dep_time))
summary(flights)
NA | TRUE
NA ^0
NA^10
