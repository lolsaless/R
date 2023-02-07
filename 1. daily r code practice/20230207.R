library(tidyverse)
diamonds
aggregate(price ~ cut, diamonds, mean)

diamonds %>% group_by(cut) %>% 
  summarise(mean_price = mean(price)) %>% 
  arrange(desc(mean_price))
diamonds %>% select(ends_with("t"))

library(nycflights13)
flights

flights %>% 
  select(where(is.character))
flights %>% 
  select(where(is.numeric))

flights %>% 
  relocate(dep_delay:arr_delay, .before = year)
flights %>% 
  relocate(starts_with("arr"), .before = dep_time)

flights %>% 
  relocate(ends_with("delay"), .before = year)

flights %>% 
  group_by(month) %>% 
  summarise(
    delay = mean(dep_delay)
  )

flights %>% 
  group_by(month) %>% 
  summarise(delay = mean(dep_delay, na.rm = TRUE))

flights %>% 
  group_by(month) %>% 
  summarise(delay = mean(dep_delay, na.rm = TRUE),
            n = n()) %>% 
  arrange(desc(delay))
            

#다중변수로 그룹화 하기
daily <- flights %>% 
  group_by(year, month, day)
daily

daily %>% 
  summarise(n = n())


#그룹화의 차이점을 잘 모르겠음. 차이가 없음???
daily %>% 
  summarise(n = n(),
            .groups = "drop_last")

daily %>% 
  summarise(n = n(),
            .groups = "drop")
daily %>% 
  summarise(n = n(),
            .groups = "keep")

a = NA
is.na(a)

!is.na(a)

delays <- flights %>% 
  filter(!is.na(arr_delay)) %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay),
    n = n()
  )

mean(flights$year)
mean(flights$dep_delay, na.rm = TRUE)

#앞의 !is.na에서 NA값을 제거했기 때문에 뒤에서는 na.rm 이 필요하지 않다.
flights %>% summarise(aaa = mean(arr_delay, na.rm = TRUE))
flights %>% filter(!is.na(arr_delay)) %>% 
  summarise(delay = mean(arr_delay))


delays <- flights %>% filter(!is.na(arr_delay)) %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay),
    n = n()
  )

ggplot(delays, aes(delay)) +
  geom_freqpoly(binwidth = 10)

ggplot(delays, aes(n, delay)) +
  geom_point(alpha = 1/10)

delays %>% 
  filter(n > 25) %>% 
  ggplot(aes(n, delay)) +
  geom_point(alpha = 1/10) +
  geom_smooth(se = FALSE)
