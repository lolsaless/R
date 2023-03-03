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

table1 %>% mutate(rate = cases / population * 10000)

table1 %>% count(year, wt = cases)

table1 %>% group_by(year) %>% 
  summarise(n = sum(cases))

#table2와 table4a + 4b에서 비율을 계산하라.

t2_cases <- filter(table2, type == "cases") %>% 
  rename(cases = count) %>% 
  arrange(country, year)

t2_population <- filter(table2, type == "population") %>% 
  rename(population = count) %>% 
  arrange(country, year)

t2_cases
t2_population
