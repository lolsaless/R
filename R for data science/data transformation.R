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

#연습문제
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


df <- tibble(x = c(5,2,NA))
arrange(df, x)
dfs <- data.frame(x = c(5,2,NA))

flights %>% arrange(desc(is.na(dep_time)))
flights %>% arrange(desc(dep_delay)) %>% head(5)


#select

flights %>% select(-c(year:day)) %>% head(5)
flights %>% select(!starts_with('y')) %>% head(5)
?select                   
flights
flights %>% rename(tail_num = tailnum)
flights %>% select(time_hour, air_time, everything())
flights %>% select(starts_with(c('dep', 'arr')))


#mutate
flights_sm1 <- flights %>% select(year:day,
                                  ends_with("delay"),
                                  distance,
                                  air_time)
flights_sm1 <- flights_sm1 %>% mutate(gain = arr_delay - dep_delay,
                                      speed = distance/air_time * 60)
flights_sm1

transmute(flights,
          gain = arr_delay - dep_delay,
          hours = air_time/60,
          gain_per_hour = gain/hours)

y <- c(1,2,2,3,4)
min_rank(y)
min_rank(desc(y))

a <- flights %>% select(air_time, arr_time, dep_time)
aa <- a %>% mutate(time = arr_time - dep_time)
aa %>% select(time, everything())

dep <- flights %>% select(contains('dep'))

flights %>% mutate(time = time2mins(dep_time)) %>% arrange(desc(time))


time2mins <- function(x) {
  (x %/% 100 * 60 + x %% 100) %% 1440
}


1:3 + 1:10

summarize(flights, aaa = mean(dep_delay, na.rm = TRUE))
flights %>% group_by(month) %>% summarise(a = mean(dep_delay, na.rm = TRUE))

flights
flights %>% group_by(dest) %>% summarise(count = n(),
                                         dist = mean(distance, na.rm = T),
                                         delay = mean(arr_delay, na.rm = T)) %>% 
  filter(count > 20, dest != 'HNL')
