library(tidyverse)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

#연습문제
#1. ggplot(data = mpg)을 실행해라. 어떤 것이 나오는가?
ggplot(data = mpg)
#빈 화면이 나온다. 그려질 것들이 맵핑 되지 않아서 그런 것 같다.

rownames(mpg)
row(mpg)
?mpg

ggplot(data = mpg) +
  geom_point(mapping = aes(x = hwy, y = cyl))

summary(mpg)


#이 둘의 차이점을 이해 해야한다.
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = "blue"))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), color = "red")


ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size = class))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))
