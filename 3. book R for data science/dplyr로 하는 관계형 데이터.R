library(tidyverse)
library(nycflights13)

airlines
airports
planes
airlines
flights
arrange(desc(airports$lat))

planes %>% 
  count(year) %>% 
  arrange(desc(n))

weather %>% 
  count(year, month, day, hour, origin) %>% 
  filter(n > 1)

flights %>% count(tailnum)

f2 <- flights %>% 
  select(year, month, day, hour, origin, dest, tailnum, carrier)
f2

f2 %>% select(-origin, -dest) %>% 
  left_join(airlines, by = 'carrier')

f2 %>%
  select(-c(origin, dest)) %>% 
  mutate(airlines_name = airlines$name[match(carrier, airlines$carrier)])

x <- tribble(
  ~key, ~val_x,
  1, 'x1',
  2, 'x2',
  3, 'x3'
)
x

y <- tribble(
  ~key, ~val_y,
  1, 'y1',
  2, 'y2',
  4, 'y3'
)
y
x %>% left_join(., y, by = 'key')
x %>% inner_join(., y, by = 'key')


f2
weather
f2 %>% left_join(weather)
flights
planes
f2 %>% left_join(planes, by = 'tailnum')

planes %>% count(manufacturer) %>% arrange(desc(n))

head(f2)

top_dest <- f2 %>% 
  count(dest, sort = TRUE) %>% 
  head(10)
top_dest

top_dest <- f2 %>% 
  count(dest) %>% 
  arrange(n) %>% 
  head(10)
top_dest

#count 함수에서 sort = TRUE 사용하면, arrange(desc())와 같음.

f2 %>% 
  filter(dest %in% top_dest$dest)
planes
f2 %>% 
  anti_join(planes, by = 'tailnum') %>% 
  count(tailnum, sort = )