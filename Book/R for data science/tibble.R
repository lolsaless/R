library(tidyverse)
iris
str(iris)
head(iris)
as_tibble(iris)
#tibble()을 사용하여 개별 벡터로부터 새로운 티블을 만들 수 있다.
#tibble()은 길이가 1인 입력을 자동으로 재사용하며, 여기에서 보이는 것 처럼 방금 만든 변수를 참소할 수 도 있다.


tibble(
  x = 1:5,
  y = 1,
  z = x^2 + y
)

library(lubridate)

tibble(
  a = now() + runif(1000) + 86400,
  b = today() + runif(1000) + 30,
  c = 1:1000,
  d = runif(1000),
  e = sample(letters, 1000, replace = T)
)

letters
now()
runif(1000)

nycflights13::flights %>% 
  print(n=10, width = Inf)

df <- tibble(
  x = runif(5),
  y = rnorm(5)
)
df
df$x
df[['x']]
df[[1]]
df[, 1]
df[, 2]
df[1]
df[2]
df[[2]]

df %>% .$x
is_tibble(mtcars)
as_tibble(mtcars)
var <- "mpg"
var[[1]]

annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)
annoying$`1`
annoying[1]
annoying[[1]]
annoying %>% plot(1,2)
annoying$`3` <- tibble(`3` = annoying[2] / annoying[1])
annoying

annoying %>% mutate(`3` = `2`/`1`)



parse_double('1.23')
parse_double('222')
parse_integer('111212')
parse_number('$$@#$@%@werewrs234234234@@#$@#$')
parse_number('123.123.123', locale = locale(grouping_mark = '.'))
charToRaw('hadely')             
charToRaw('조의호')


challenge <- read_csv(readr_example('challenge.csv'))
problems(challenge)

aa <- read_csv(
  readr_example('challenge.csv'),
  col_types = cols(
    x = col_integer(),
    y = col_character()
  )
)
aa
aaa <- read_csv(
  readr_example('challenge.csv'),
  col_types = cols(
    x = col_double(),
    y = col_date()
  )
)
aaa
table1 %>% 
  mutate(rate = cases/population * 10000)
table1 %>% 
  count(year, wt = cases)
table1 %>% 
  count(year, wt = )


library(ggplot2)
ggplot(table1, aes(year, cases)) +
  geom_line(aes(group = country), color = 'grey50') +
  geom_point(aes(color = country))


table4a
table1

a <- table4a %>% 
  gather(`1999`, `2000`, key = 'year', value = 'cases')

table4a %>% select(country, `1999`, `2000`) %>% 
  gather(key = 'year', value = 'cases')

table4b
b <- table4b %>% 
  gather(`1999`, `2000`, key = 'year', value = 'population')

left_join(a,b)

table2 %>% 
  spread(key = type, value = count)

stock <- tibble(
  year = c(2015,2015,2016,2016),
  half = c(1,2,1,2),
  return = sample(1:4)
)

stock %>% spread(year, return) %>% 
  gather(`2015`, `2016`, key= 'year', value = 'return')

stock %>% spread(year, return) %>% 
  gather('year', 'return', `2015`:`2016`)

# 7.데이터 타이디하게 학기
table1
table2
table3
table4a
table4b

table1 %>% mutate(rate = cases / population * 10000)
table1 %>% count(cases, wt = year)
?count

table4a %>% gather(`1999`, `2000`, key = "year", value = "cases") %>% 
  mutate(year = parse_integer(year))
table4b %>% gather(`1999`, `2000`, key = "year", value = "population")

tidy4a <- table4a %>% gather(`1999`, `2000`, key = "year", value = "cases") %>% mutate(year = parse_integer(year))

tidy4b <- table4b %>% gather(`1999`, `2000`, key = "year", value = "population") %>% mutate(year = parse_integer(year))

left_join(tidy4a, tidy4b)

str(tidy4a)
str(tidy4b)
