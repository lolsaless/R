library(tidyverse)

ggplot(diamonds, aes(cut)) +
  geom_bar()

diamonds %>% count(cut)
table(diamonds$cut)

diamonds %>% 
  count(cut_width(carat, 0.5))

diamonds %>% 
  filter(carat < 3) %>% 
  ggplot(., aes(carat)) +
  geom_histogram(binwidth = 0.01)

diamonds %>% 
  filter(carat < 3) %>% 
  ggplot(aes(carat, color = cut)) +
  geom_freqpoly(binwidth = 0.01)

head(diamonds)
ggplot(diamonds, aes(y)) +
  geom_histogram(binwidth = 0.5)

#이상값을 쉽게 확인하기 위해서는 다음과 같이 한다.
ggplot(diamonds, aes(y)) +
  geom_histogram(binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50),
                  xlim = c(30, 40))
?coord_cartesian                  

diamonds %>% filter(y < 3 | y > 20) %>% 
  select(price, x, y, z) %>% 
  arrange(y)

?diamonds

ggplot(diamonds, aes(price)) +
  geom_histogram(binwidth = 10)

ggplot(diamonds, aes(cut, price)) +
  geom_boxplot()

ggplot(diamonds, aes(carat, price)) +
  geom_point() +
  geom_smooth()

diamonds %>% filter(carat == 0.99) %>% 
  group_by(cut) %>% 
  summarise(n = n())

diamonds %>% filter(carat == 1) %>% 
  group_by(cut) %>% 
  summarise(n = n())

diamonds %>% 
  filter(carat >= 0.99, carat <= 1) %>% 
  count(carat)

diamonds %>% 
  count(cut_width(carat, 0.5))

#결측값 처리
dia2 <- diamonds %>% mutate(y = ifelse(y < 3 | y > 20, NA, y))

ggplot(dia2, aes(x, y)) +
  geom_point(na.rm = TRUE)

dia2 %>% count(is.na(y))

?geom_histogram
?geom_bar

ggplot(diamonds, aes(price, after_stat(density))) +
  geom_freqpoly(aes(color = cut), binwidth = 500)

ggplot(diamonds, aes(cut, price)) +
  geom_boxplot()


ggplot(mpg, aes(x = reorder(class, hwy, FUN = median), y = hwy)) +
  geom_boxplot()
