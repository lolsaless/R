library(tidyverse)

#범주형 데이터(categorical)
ggplot(diamonds, aes(cut)) +
  geom_bar()

diamonds %>% count(cut) %>% 
  arrange(desc(.))

#연속형 데이터(continuous)
diamonds
ggplot(diamonds, aes(depth)) +
  geom_histogram()

ggplot(diamonds, aes(carat)) +
  geom_histogram(binwidth = 0.6)


#연속형 변수를 범주형 변수로 변환하여 카운트 할  수 있다.
diamonds %>% count(cut_width(depth, 10))
diamonds %>% count(cut_width(carat, 0.5))

ggplot(diamonds, aes(depth)) +
  geom_histogram()
dim(diamonds)

diamonds %>% count(cut_width(carat, 0.1))

smaller <- diamonds %>% 
  filter(carat < 3)
ggplot(smaller, aes(carat)) +
  geom_histogram(binwidth = 0.1)

depth_diamond <- diamonds %>% 
  filter(depth >= 60 & depth <= 65)

ggplot(depth_diamond, aes(depth)) +
  geom_histogram()

ggplot(smaller, aes(carat, color = cut)) +
  geom_freqpoly(binwidth = 0.1)

ggplot(smaller, aes(carat)) +
  geom_histogram(binwidth = 0.01)


ggplot(faithful, aes(eruptions)) +
  geom_histogram(binwidth = 0.25)

#히스토그램 y축을 확대하여 이상값을 확인한다.
ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))

#이상값 추출
unusual <- diamonds %>% 
  filter(y < 3 | y > 20) %>% 
  select(price, x, y, z) %>% 
  arrange(y)
unusual

#결측값
diamonds2 <- diamonds %>% 
  filter(between(y, 3, 20))
diamonds2 %>% select(price, x, y, z) %>% 
  arrange(y)

diamonds3 <- diamonds %>% 
  mutate(y = ifelse(
    y < 3 | y > 20, NA, y)
  )
?case_when

ggplot(diamonds3, aes(x, y)) +
  geom_point(na.rm = TRUE)

nycflights13::flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot(aes(sched_dep_time)) +
  geom_freqpoly(aes(color = cancelled), binwidth = 1/4)


cancelled_flights <- nycflights13::flights

cancelled_flights %>% count(dep_time, NA) %>% tail(5)

#공변동
ggplot(diamonds, aes(price)) +
  geom_freqpoly(aes(color = cut), binwidth = 500)

ggplot(diamonds, aes(price, ..density..)) +
  geom_freqpoly(aes(color = cut), binwidth = 500)

ggplot(diamonds, aes(price, after_stat(density))) +
  geom_freqpoly(aes(color = cut), binwidth = 500)

ggplot(diamonds, aes(cut, price)) +
  geom_boxplot()

mpg
ggplot(mpg) +
  geom_boxplot(aes(x = reorder(class, hwy, FUN = median), hwy))

ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy))
