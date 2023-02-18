library(tidyverse)

ggplot(mpg, aes(cty, hwy)) +
  geom_point()

ggplot(midwest, aes(poptotal, popasian)) +
  geom_point() +
  xlim(0,500000) +
  ylim(0, 10000)

#막대 그래프 집단 간 차이 표현하기

ggplot(mpg, aes(reorder(drv, hwy), hwy)) +
  geom_col()

df_mpg <- mpg %>% group_by(drv) %>% 
  summarise(mean_hwy = mean(hwy))

ggplot(df_mpg, aes(reorder(drv, -mean_hwy), mean_hwy)) +
  geom_col()

df_suv_mpg <- mpg %>% filter(class == "suv") %>% 
  group_by(manufacturer) %>% 
  summarise(mean_cty = mean(cty)) %>%
  arrange(desc(mean_cty)) %>% 
  head(5)

df_suv_mpg

ggplot(df_suv_mpg, aes(reorder(manufacturer, -mean_cty), mean_cty)) +
  geom_col()

ggplot(mpg, aes(class)) +
  geom_bar()

df_class_mpg <- mpg %>% group_by(class) %>% 
  summarise(cnt = n())

ggplot(df_class_mpg, aes(reorder(class, -cnt), cnt)) +
  geom_bar(stat = "identity")

ggplot(df_class_mpg, aes(reorder(class, -cnt), cnt)) +
  geom_col()

ggplot(df_class_mpg, aes(reorder(class, -cnt), cnt)) +
  geom_bar()
