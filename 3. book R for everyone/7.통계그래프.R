ggplot(diamonds, aes(carat)) +
  geom_histogram()

ggplot(diamonds, aes(carat)) +
  geom_density(fill = "grey50")

ggplot(diamonds) +
  geom_density(aes(carat, fill = "324234", color = "black"))

ggplot(diamonds, aes(carat, price)) +
  geom_point()

g <- ggplot(diamonds, aes(carat, price))

g + geom_point(aes(color = cut))
view(diamonds)

g + geom_point(aes(color = color)) +
  facet_wrap(~color)

?ggplot2
?aes

ggplot(diamonds, aes(carat)) +
  geom_boxplot()
ggplot(diamonds, aes(y = carat)) +
  geom_boxplot()

ggplot(diamonds, aes(y = carat, x = cut)) +
  geom_boxplot()

library(lubridate)

e <- economics
e <- e %>% mutate(year = year(.$date),
                  month = month(.$date, label = TRUE),
                  .before = 1)
#label 인자는 숫자가 아닌 이름으로 반환
?month

econ2000 <- e %>% mutate(Test = .$year >= 2000)
colnames(econ2000)
head(econ2000)

econ2000_1 <- e %>% filter(.$year >= 2000)
econ2000_1

e %>% group_by(year) %>% 
  summarise(unemploy) %>% 
  arrange(desc(unemploy)) %>% 
  head(5)

