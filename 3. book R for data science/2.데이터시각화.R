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
  geom_point(mapping = aes(x = displ, y = hwy, color = "red"))


ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), color = "red")


ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size = class))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = drv))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = drv))


ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ cyl)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)

ggplot(data = mpg) +
  geom_line(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv, color = drv))

ggplot(data = mpg) +
  geom_line(mapping = aes(x = displ, y = hwy, linetype = drv, color = drv))

ggplot(mpg) +
  geom_smooth(aes(displ, hwy))
ggplot(mpg) +
  geom_smooth(aes(displ, hwy, group = drv))
ggplot(mpg) +
  geom_smooth(aes(displ, hwy, color = drv))
ggplot(mpg) +
  geom_smooth(aes(displ, hwy, color = drv),
              show.legend = FALSE)

ggplot(mpg) +
  geom_point(aes(displ, hwy)) +
  geom_smooth(aes(displ, hwy, color = drv, linetype = drv),
              show.legend = FALSE)

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_smooth(aes(color = drv, linetype = drv),
              show.legend = FALSE)

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(aes(linetype = drv))

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)

head(diamonds)
dim(diamonds)

ggplot(diamonds) +
  geom_bar(aes(cut))
unique(diamonds$cut)
class(diamonds$cut)
a <- as.vector(diamonds$cut)
class(a)
unique(a)

?diamonds

ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) + 
  geom_bar(alpha = 1/5, position = "identity")
ggplot(data = diamonds, mapping = aes(x = cut, colour = clarity)) + 
  geom_bar(fill = NA, position = "identity")

ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) + 
  geom_bar(alpha = 1/5, position = "dodge")
ggplot(data = diamonds, mapping = aes(x = cut, colour = clarity)) + 
  geom_bar(fill = NA, position = "identity")

ggplot(mpg, aes(class, hwy)) +
  geom_boxplot() +
  coord_flip()

