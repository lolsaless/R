library(nycflights13)
library(tidyverse)

flights
table(flights$origin)

test1 <- flights %>% filter(month == 11 | month == 12)

test2 <- flights %>% filter(month %in% c(11, 12))

colnames(flights)

#2시간 이상 도착 지연
flights %>% filter(arr_delay > 120)

#IAH HOU 운항
flights %>% filter(dest %in% c("IAH", "HOU"))

#UA, AA, DL항공 운항
flights %>% filter(carrier %in% c("UA", "AA", "DL"))

#7,8,9월 출발
flights %>% filter(month %in% c(7, 8, 9))

flights %>% filter(arr_delay > 120 & dep_delay <= 0)

flights %>% filter(dep_delay > 60, dep_delay - arr_delay > 30)

flights %>% mutate(time =
                     dep_delay - arr_delay,
                   .before = 1)

head(flights)

flights %>% filter(is.na(dep_time))


NA | TRUE

NA | FALSE

NA & TRUE

NA & FALSE
