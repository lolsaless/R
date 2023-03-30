library(tidyverse)

table3_2 <- table3 %>% 
  separate(rate, into = c("cases", "population"), sep = "/", convert = TRUE) %>% 
  separate(year, into = c("century", "year"), sep = 2, convert = TRUE)

table3_2 %>% 
  unite(rate, cases, population, sep = "/" ) %>% 
  unite(new, century, year, sep = "")


table3_3 <- table3
for (i in 1:nrow(table3_3)) {
  table3_3[i, "cases"] = strsplit(table3$rate[i], split = "/")[[1]][1]
  table3_3[i, "population"] =strsplit(table3$rate[i], split = "/")[[1]][2]
}
strsplit(table3$rate[1], split = "/")[[1]][1]
strsplit(table3$rate[1], split = "/")[[1]][2]
strsplit(table3$rate[1], split = "/")

table3_3
table3 %>% 
  separate(rate, into = c("cases", "population"), sep = "/", convert = TRUE, remove = FALSE)


?unite

table5
table5 %>% 
  unite(new, century, year, sep = "")

df <- tibble(x = c(NA, "x.y", "x.z", "y.z"))
df %>% separate(x, c("A", "B"))

?separate

tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>%
  separate(x, c("one", "two", "three"))

tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>%
  separate(x, c("one", "two", "three"), extra = "drop")

tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>%
  separate(x, c("one", "two", "three"), extra = "merge")


tibble(x = c("a,b,c", "d,e", "f,g,i")) %>%
  separate(x, c("one", "two", "three"))

tibble(x = c("a,b,c", "d,e", "f,g,i")) %>%
  separate(x, c("one", "two", "three"), fill = "right")

tibble(x = c("a,b,c", "d,e", "f,g,i")) %>%
  separate(x, c("one", "two", "three"), fill = "left")

tibble(x = c("X_1", "X_2", "AA_1", "AA_2")) %>%
  separate(x, c("variable", "into"), sep = "_")

tibble(x = c("X1", "X2", "Y1", "Y2")) %>%
  separate(x, c("variable", "into"), sep = 1)

tibble(x = c("X_1", "X_2", "AA_1", "AA_2")) %>%
  extract(x, c("variable", "id"), regex = "([A-Z])_([0-9])")

tibble(x = c("X1", "X2", "Y1", "Y2")) %>%
  extract(x, c("variable", "id"), regex = "([A-Z])([0-9])")

tibble(x = c("X1", "X20", "AA11", "AA2")) %>%
  extract(x, c("variable", "id"), regex = "([A-Z]+)([0-9]+)")

stocks <- tibble(
  year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr    = c(   1,    2,    3,    4,    2,    3,    4),
  return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)

stocks %>% 
  spread(year, return) %>% 
  gather(year, return, `2015`:`2016`, na.rm = TRUE)

stocks %>% 
  complete(year, qtr)

stocks
stocks %>% 
  spread(year, return, fill = 0) %>% 
  gather(year, return, `2015`:`2016`, na.rm = TRUE)

?fill

stocks %>% rename(aaaa = return) %>% 
  complete(year, qtr, fill = list(aaaa = 0))


stocks %>% 
  complete(year, qtr) %>% 
  fill(return, .direction = "up")
complet

who

who1 <- who %>% gather(
  new_sp_m014:newrel_f65, key = "key",
  value = "cases",
  na.rm = TRUE
)

who1

who1 %>% count(key, wt = cases)

who2 <- who1 %>% 
  mutate(key = str_replace(key, "newrel", "new_rel"))

who3 <- who2 %>% 
  separate(key, c("new", "type", "sexage"), sep = "_")
who3

who4 <- who3 %>% 
  select(-new, -iso2, -iso3)

who5 <- who4 %>% 
  separate(sexage, c("sex", "age"), sep = 1)
who5

who5 %>% mutate(age = str_replace(age, "014", "0014"))
table(who5$age)


?gather
who %>% 
  gather(code, value, new_sp_m014:newrel_f65, na.rm = TRUE)
who %>% 
  gather(new_sp_m014:newrel_f65, key = code, value = value, na.rm = TRUE)

who %>% 
  gather(code, value, new_sp_m014:newrel_f65, na.rm = TRUE) %>% 
  mutate(code = str_replace(code, "newrel", "new_rel")) %>% 
  separate(code, into = c("new", "type", "sexage"), sep = "_") %>% 
  separate(sexage, into = c("sex", "age"), sep = 1) %>% 
  select(-iso2, -iso3, -new) %>% 
  group_by(country) %>% 
  summarise(n = n())


?distinct
select(who3, country, iso2, iso3) %>% 
  distinct()

who5 %>% 
  group_by(country, year, sex) %>% 
  filter(year > 1995) %>% 
  summarise(cases = sum(cases)) %>% 
  unite(country_sex, country, sex, remove = FALSE) %>% 
  ggplot(aes(year, cases, group = country_sex, color = sex)) +
  geom_line()
