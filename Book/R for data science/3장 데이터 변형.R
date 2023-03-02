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


#3.3.1연습문제
flights %>% arrange(desc(is.na(dep_time)))
flights %>% arrange(desc(arr_delay))
flights %>% mutate(dis_time = distance/air_time,
                   .before = 1) %>% 
  arrange(dis_time)
view(flights)
flights %>% arrange(distance)

flights %>% select(origin, dest, everything())

#3.4.1연습문제
flights %>% select(starts_with(c("dep", "arr")))

?select

flights %>% select(contains("TIME"))
#R은 원칙적으로 대소문자를 구분하지만, select의 contains함수는 구분하지 않는다.

flights %>% group_by(year, month) %>% 
  summarise(delay = mean(dep_delay, na.rm = TRUE))

delay <- flights %>% group_by(dest) %>% 
  summarise(count = n(),
            dist = mean(distance, na.rm = TRUE),
            delay = mean(arr_delay, na.rm = TRUE)) %>% 
  filter(count > 20 & dest != "HNL")

ggplot(delay, aes(dist, delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)

not_cancelled <- flights %>% filter(!is.na(dep_delay),
                                    !is.na(arr_delay)) %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))

not_cancelled <- flights %>% filter(!is.na(dep_delay & arr_delay)) %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))

not_cancelled <- flights %>% filter(!is.na(dep_delay), !is.na(arr_delay))

delays <- not_cancelled %>% group_by(tailnum) %>% 
  summarise(delay = mean(arr_delay))

ggplot(delays, aes(delay)) +
  geom_freqpoly(binwidth = 10)

flights %>% filter(!is.na(dep_delay), !is.na(arr_delay)) %>% 
  group_by(tailnum) %>% 
  summarise(delay = mean(arr_delay),
            n = n()) %>% 
  filter(n > 25) %>% 
  ggplot(., aes(n, delay)) +
  geom_point(alpha = 1/10)

library(Lahman)
install.packages("Lahman")
summary(batting)

batting <- as.tibble(Lahman::Batting)

batters <- batting %>% 
  group_by(playerID) %>% 
  summarise(ba = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
            ab = sum(AB, na.rm = TRUE))

batters %>% filter(ab > 100) %>% 
  ggplot(., aes(ab, ba)) +
  geom_point(alpha = 1/10) +
  geom_smooth(se = FALSE)

table(not_cancelled$carrier)

not_cancelled %>% group_by(dest) %>% 
  summarise(carriers = n_distinct(carrier)) %>% 
  arrange(desc(carriers))

flights %>% count(dest, wt = distance) %>% 
  ggplot(., aes(dest, n)) +
  geom_col() +
  coord_flip()

flights %>% group_by(year, month, day) %>% 
  summarise(cnt = n())
