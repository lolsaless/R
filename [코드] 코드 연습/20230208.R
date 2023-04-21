library(tidyverse)
table1
table1
table2
table3

a <- table1
a <- left_join(a, table2, by = "country")

#tidy한 데이터는 table1.
view(table1)
view(table2)
view(table3)
view(table4a)
view(table4b)

table1 %>% 
  mutate(rate = cases / population * 10000)
table1 %>% 
  count(year, wt = cases)

table1 %>% filter(year == 1999) %>% 
  count(year, wt = cases)

ggplot(table1, aes(year, cases)) +
  geom_line(aes(group = country), color = "grey50") +
  geom_point(aes(color = country, shape = country)) +
  scale_x_continuous(breaks = c(1999,2000))

a <- table4a %>% 
  pivot_longer(c("1999", "2000"), names_to = "year", values_to = "cases")
b <- table4a %>% 
  gather("1999", "2000", key = "year", value = "cases") %>% 
  arrange(country)

identical(a,b)
view(a)
view(b)


#gather함수에 대한 설명
?gather
stocks <- tibble(
  time = as.Date('2009-01-01') + 0:9,
  X = rnorm(10, 0, 1),
  Y = rnorm(10, 0, 2),
  Z = rnorm(10, 0, 4)
)
view(stocks)
stocks %>% gather("A", "B", -time) %>% view()


table4a
a <- table4a %>% mutate('2001' = `1999`/`2000`)
a %>% gather(c("1999", "2000", "2001"), key = "year", value = "cases")

table4b
table4b %>% gather(`1999`,`2000`, key = "year", value = "population")