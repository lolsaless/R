library(tidyverse)
ggplot(mpg, aes(displ, hwy)) +
  geom_point()

ggplot(mpg, aes(cty, hwy)) +
  geom_point()

ggplot(midwest, aes(poptotal, popasian)) +
  geom_point() +
  xlim(0, 500000) +
  ylim(0, 10000)

df_mpg <- mpg %>% 
  group_by(drv) %>% 
  summarise(mean_hwy = mean(hwy))

ggplot(df_mpg, aes(drv, mean_hwy)) +
  geom_boxplot()

ggplot(df_mpg, aes(reorder(drv, -mean_hwy), mean_hwy)) +
  geom_col()


#reorder 사용법법
ggplot(mpg, aes(drv)) +
  geom_bar()

drv_mpg <- mpg %>% group_by(drv) %>% 
  summarise(cnt = n()) %>% 
  arrange(desc(cnt))

ggplot(drv_mpg, aes(reorder(drv, -cnt), cnt)) +
  geom_col()

ggplot(mpg, aes(hwy)) +
  geom_bar()

cty_mpg <- mpg %>% filter(class == "suv") %>% 
  group_by(manufacturer) %>% 
  summarise(cty_mean = mean(cty)) %>% 
  arrange(desc(cty_mean)) %>% 
  head(5)

cty_mpg
ggplot(cty_mpg, aes(reorder(manufacturer, -cty_mean), cty_mean)) +
  geom_col()

ggplot(mpg, aes(class)) +
  geom_bar()

ggplot(economics, aes(date, unemploy)) + 
  geom_line()

economics

ggplot(economics, aes(date, psavert)) +
  geom_line()
