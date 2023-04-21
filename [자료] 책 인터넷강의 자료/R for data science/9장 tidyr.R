library(tidyverse)

table1
table2
table3
table4a
table4b

diamonds %>% count(cut_width(carat, 0.2)) %>% 
  rename(size = "cut_width(carat, 0.2)",
         counts = "n") %>% 
  ggplot(., aes(size, counts)) +
  geom_point() +
  coord_flip()

table1 %>% mutate(rate = cases / population * 10000) %>% 
  select(year, country, cases, population, rate)

table1 %>% count(year, wt = cases)
table1 %>% count(year)
?count

table1 %>% group_by(year) %>% 
  summarise(n = sum(cases))

#table2와 table4a + 4b에서 비율을 계산하라.

t2_cases <- filter(table2, type == "cases") %>% 
  rename(cases = count) %>% 
  arrange(country, year)

t2_population <- filter(table2, type == "population") %>% 
  rename(population = count) %>% 
  arrange(country, year)

#left join
t2_cases
t2_population
left_join(t2_cases, t2_population)

t2_cases[3] <- NULL
t2_population[3] <- NULL
left_join(t2_cases, t2_population) %>% arrange(year)


t2_cases_per_cap <- tibble(
  year = t2_cases$year,
  country = t2_cases$country,
  cases = t2_cases$cases,
  population = t2_population$population
) %>% 
  mutate(cases_per_cap = (cases / population) * 10000)

t2_cases_per_cap

t2_cases_per_cap <- t2_cases_per_cap %>%
  mutate(type = "cases_per_cap") %>%
  rename(count = cases_per_cap)

t2_cases_per_cap

bind_rows(table2, t2_cases_per_cap) %>% 
  arrange(country, year, type, count)

table4a
table4b$`1999`
table4c <- tibble(
  country = table4a$country,
  `1999` = table4a[["1999"]] / table4b[["1999"]] * 10000,
  `2000` = table4a[["2000"]] / table4b[["2000"]] * 10000
)

table4c <- tibble(
  country = table4a$country,
  `1999` = table4a[2] / table4b[2] * 10000,
  `2000` = table4a[3] / table4b[3] * 10000
)
table4c <- tibble(
  country = table4a$country,
  `1999` = table4a[[2]] / table4b[[2]] * 10000,
  `2000` = table4a[[3]] / table4b[[3]] * 10000
)

table4c
table1


#gater와 pivoting

table4a

table4a %>% 
  gather(`1999`, `2000`, key = "year", value = "cases")

table4a %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "cases")

table4b %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "population")

table4c %>% 
  gather(`1999`, `2000`, key = "year", value = "percent")

#spread와 pivoting
table2 %>% 
  spread(key = type, value = count)

stocks <- tibble(
  year   = c(2015, 2015, 2016, 2016),
  half  = c(   1,    2,     1,    2),
  return = c(1.88, 0.59, 0.92, 0.17)
)
stocks
stocks %>% spread(year, return) %>% 
  gather("year", "return", `2015`:`2016`)

stocks %>%
  pivot_wider(names_from = year, values_from = return)%>%
  pivot_longer(`2015`:`2016`, names_to = "year", values_to = "return",
               names_transform = list(year = as.numeric)
               )
#안됨
stocks %>% 
  spread(key = year, value = return) %>% 
  gather(`2015`:`2016`, key = "year", value = "return",
         convert = list(year = as.numeric))

?gather
?pivot_longer

table4a %>% 
  pivot_longer(c(1999, 2000), names_to = "year", values_to = "cases")

table4a %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "cases")

people <- tribble(
  ~name, ~key, ~value,
  #-----------------|--------|------
  "Phillip Woods",  "age", 45,
  "Phillip Woods", "height", 186,
  "Phillip Woods", "age", 50,
  "Jessica Cordero", "age", 37,
  "Jessica Cordero", "height", 156
)
people

stocks <- tibble(
  year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr    = c(   1,    2,    3,    4,    2,    3,    4),
  return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)

stocks

stocks %>% spread(key = year, value = return)
stocks %>% complete(year, qtr)


treatment <- tribble(
  ~person,           ~treatment, ~response,
  "Derrick Whitmore", 1,         7,
  NA,                 2,         10,
  NA,                 3,         9,
  "Katherine Burke",  1,         4
)

treatment
treatment %>% fill(person)

