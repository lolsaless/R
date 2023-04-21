table1
table2
table3

#table2를 table1 처럼 만들기 1
t_case <- table2 %>% filter(type == "cases") %>% 
  rename("cases" = count)

t_population <- table2 %>% filter(type == "population") %>% 
  rename("population" = count) %>% 
  arrange(country, year)

t_case[3] <- NULL
t_population[3] <- NULL

t_case
t_population

left_join(t_case, t_population)

#table2를 table1 처럼 만들기 2
t_join <- tibble(
  country = t_case$country,
  year = t_case$year,
  cases = t_case$cases,
  population = t_population$population
  
)
t_join

table1 %>% count(year, wt = cases)
table1 %>% count(country, wt = population)

library(nycflights13)

airlines
airports
planes
weather

flights2 <- flights %>% 
  select(year:day, hour, origin, dest, tailnum, carrier)

flights2 %>% left_join(airlines, by = "carrier")

#잘못된 방식.
flights2 %>% mutate(name = .$carrier == airlines$carrier, airlines$name, NA)

#정답
flights2 %>% mutate(name = airlines$name[match(carrier, airlines$carrier)])