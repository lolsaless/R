library(tidyverse)
library(forcats)

x1 <- c("Dec", "Apr", "Jan", "Mar")
str(x1)
x2 <- x1

x2[3] <- "Jam"
x2

month_level <- c(
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec"
)
month_level

y1 <- factor(x1, levels = month_level)
y1
sort(y1)
y2 <- factor(x2, levels = month_level)
y2
sort(y2)

x1
factor(x1)

gss_cat

gss_cat %>% count(race)
?gss_cat

relig_summary <- gss_cat %>% 
  group_by(relig) %>% 
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )
relig_summary


relig_summary %>% 
  mutate(relig = fct_reorder(relig, tvhours, .fun = min)) %>% 
  ggplot(aes(tvhours, relig)) + geom_point()

rincome_summary <- gss_cat %>% 
  group_by(rincome) %>% 
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    count = n()
  )

rincome_summary %>% 
  mutate(rincome = fct_reorder(rincome, age)) %>% 
  ggplot(aes(age, rincome)) + geom_point()

