library(tidyverse)
library(lubridate)
library(nycflights13)

today()
now()

ymd("2023-03-21")
mdy("03-21-2023")
ymd(20230321)

flights %>% 
  select(year, month, day, hour, minute)

flights %>% 
  select(year, month, day, hour, minute) %>% 
  mutate(departure = make_datetime(year, month, day, hour, minute))

make_datetime_100 <- function(year, month, day, time) {
  make_datetime(year, month, day, time %/% 100, time %% 100)
}

flights_dt <- flights %>% 
  filter(!is.na(dep_time), !is.na(arr_time)) %>% 
  mutate(dep_time = make_datetime_100(year, month, day, dep_time),
         arr_time = make_datetime_100(year, month, day, arr_time),
         sched_dep_time = make_datetime_100(year, month, day, sched_dep_time),
         sched_arr_time = make_datetime_100(year, month, day, sched_arr_time)) %>% 
  select(origin, dest, ends_with("delay"), ends_with("time"))

flights_dt

aa <- flights %>% select(arr_time, dep_time)

aa
830 %/% 100
830 %% 100

view(flights)


flights_dt %>% 
  ggplot(aes(dep_time)) +
  geom_freqpoly(binwidth = 84600)

as_datetime(now())
now()
as_date(now())
now()

Sys.timezone()
