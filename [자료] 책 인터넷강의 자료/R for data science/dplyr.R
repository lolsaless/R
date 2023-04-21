library(tidyverse)
library(nycflights13)
airlines
view(airports)
planes
weather
view(flights)


flights_lat_lon <- flights %>% 
  inner_join(select(airports, origin = faa, origin_lat = lat, origin_lon = lon),
             by = "origin") %>% 
  inner_join(select(airports, dest = faa, dest_lat = lat, dest_lon = lon),
             by = "dest")


flights_lat_lon %>% 
  slice(1:100) %>% 
  ggplot(aes(x = origin_lon, xend = dest_lon,
             y = origin_lat, yend = dest_lat)) +
  borders("state") +
  geom_segment(arrow = arrow(length = unit(0.1, "cm"))) +
  coord_quickmap() +
  labs(y = "Latitude", x = "Longitude")



special_days <- tribble(
  ~year, ~month, ~day, ~holiday,
  2013, 01, 01, "New Years Day",
  2013, 07, 04, "Independence Day",
  2013, 11, 29, "Thanksgiving Day",
  2013, 12, 25, "Christmas Day"
)

special_days
mutate(ggplot2::diamonds, id = row_number())

distinct(diamonds, cut)

planes %>% count(tailnum) %>% 
  filter(n > 1)

distinct(planes, tailnum)

weather %>% 
  count(year) %>% 
  filter(n > 1)

weather %>% 
  count(year, month, day, hour, origin) %>% 
  filter(n > 1)

flights2 <- flights %>% 
  select(year:day, hour, origin, dest, tailnum, carrier)

flights2
airlines

flights2 %>%  select(-origin, -dest) %>% 
  left_join(airlines, by = "carrier")

flights2 %>% select(-origin, -dest) %>% 
  mutate(name = airlines$name[match(carrier, airlines$carrier)])

flights2 %>% select(-origin, -dest) %>% 
  left_join(airlines, by = "carrier")

flights2 %>% select(-origin, -dest) %>% 
  mutate(name = airlines$name[match(carrier, airlines$carrier)])

flights2 %>% 
  left_join(weather)

flights2 %>% 
  left_join(planes, by = "tailnum")
planes

flights2
unique(airports$faa)

flights2 %>% 
  left_join(airports, c("dest" = "faa"))

flights %>% 
  group_by(dest) %>% 
  summarise(delay = mean(arr_delay, na.rm = TRUE)) %>% 
  inner_join(airports, by = c(dest = "faa")) %>% 
  arrange(dest)

flights %>% 
  group_by(dest) %>% 
  summarise(delay = mean(arr_delay, na.rm = TRUE)) %>% 
  inner_join(airports, by = c(dest = "faa")) %>% 
  ggplot(aes(lon, lat, color = delay)) +
  borders("state") +
  geom_point() +
  coord_quickmap()

airports %>% 
  semi_join(flights, c("faa" = "dest")) %>% 
  ggplot(aes(lon, lat)) +
  borders("state") +
  geom_point() +
  coord_quickmap()

airport_location <- airports %>% 
  select(faa, lat, lon)

flights %>% 
  select(year:day, hour, origin, dest) %>% 
  left_join(airport_location,
            by = c("origin" = "faa")) %>% 
  left_join(airport_location,
            by = c("dest" = "faa"),
            suffix = c("_origin", "_dest"))

plane_cohorts <- inner_join(flights,
                            select(planes, tailnum, plane_year = year),
                            by = "tailnum") %>% 
  mutate(age = year - plane_year) %>% 
  filter(!is.na(age)) %>% 
  mutate(age = if_else(age > 25, 25L, age)) %>% 
  group_by(age) %>% 
  summarise(
    dep_delay_mean = mean(dep_delay, na.rm = TRUE),
    dep_delay_sd = sd(dep_delay, na.rm = TRUE),
    arr_delay_mean = mean(arr_delay, na.rm = TRUE),
    arr_delay_sd = sd(arr_delay, na.rm = TRUE),
    n_arr_delay = sum(!is.na(arr_delay)),
    n_dep_delay = sum(!is.na(dep_delay))
  )

mpg %>% select(factory = manufacturer, model)

ggplot(plane_cohorts, aes(x = age, y = dep_delay_mean)) +
  geom_point() +
  scale_x_continuous("Age of plane (years)", breaks = seq(0, 30, by = 10)) +
  scale_y_continuous("Mean Departure Delay (minutes)")

weather

flight_weather <- flights %>% inner_join(weather)

flight_weather %>%
  group_by(precip) %>%
  summarise(delay = mean(dep_delay, na.rm = TRUE)) %>%
  ggplot(aes(x = precip, y = delay)) +
  geom_line() + geom_point()
#> `summarise()` ungrouping output (override with `.groups` argument)

flights %>%
  filter(year == 2013, month == 6, day == 13) %>%
  group_by(dest) %>%
  summarise(delay = mean(arr_delay, na.rm = TRUE)) %>%
  inner_join(airports, by = c("dest" = "faa")) %>%
  ggplot(aes(y = lat, x = lon, size = delay, colour = delay)) +
  borders("state") +
  geom_point() +
  coord_quickmap() +
  scale_colour_viridis()
#> `summarise()` ungrouping output (override with `.groups` argument)
#> Warning: Removed 3 rows containing missing values (geom_point).

top_dest <- flights %>% 
  count(dest, sort = TRUE) %>% 
  head(10)
flights %>% 
  count(dest, sort = TRUE)

flights %>% 
  filter(dest %in% top_dest$dest)

flights %>% filter(is.na(tailnum), !is.na(arr_time)) %>% 
  nrow()
flights %>% filter(is.na(arr_time))

table(is.na(flights$arr_time))
table(is.na(flights$tailnum))

flights %>% 
  filter(!is.na(tailnum)) %>% 
  group_by(tailnum) %>% 
  count() %>% 
  filter(n > 100) %>% 
  arrange(desc(n))

flights %>% filter(!is.na(tailnum)) %>% 
  group_by(tailnum) %>% 
  summarise(n = n()) %>% 
  arrange(desc(n)) %>% 
  filter(n >= 100)

flights %>% filter(!is.na(tailnum)) %>% 
  group_by(tailnum) %>% 
  mutate(n = n(),
         .before = 1) %>% 
  filter(n >= 100) %>% 
  arrange(desc(n)) %>% 
  select(n, tailnum)

fueleconomy::vehicles
fueleconomy::common

fueleconomy::vehicles %>%
  semi_join(fueleconomy::common, by = c("make", "model"))

anti_join(flights, airports, by = c("dest" = "faa"))
