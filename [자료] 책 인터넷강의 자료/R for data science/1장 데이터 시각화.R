mpg

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  facet_wrap(. ~ cty)

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  facet_grid(. ~ cty)

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  facet_grid(drv ~ cty)

ggplot(mpg, aes(hwy, cty)) +
  geom_point() +
  facet_grid(drv ~ cyl)

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  facet_grid(drv ~ .)

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  facet_grid(. ~ cyl)

ggplot(mpg, aes(displ, hwy, color = drv)) +
  geom_point() +
  geom_smooth(aes(displ, hwy, linetype = drv))

ggplot(mpg, aes(displ, hwy, group = drv)) +
  geom_smooth()
ggplot(mpg, aes(displ, hwy)) +
  geom_smooth(aes(color = drv),
              show.legend = FALSE) 

ggplot(mpg, aes(displ, hwy, color = class)) +
  geom_point(show.legend = FALSE)

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(
    data = filter(mpg, class == "subcompact")
  )
?geom_smooth

ggplot(mpg, aes(displ)) +
  geom_bar()

ggplot(mpg, aes(hwy, displ)) +
  geom_area()

ggplot(mpg, aes(displ, hwy, color = drv)) +
  geom_point() +
  geom_smooth()

#Q1
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_smooth(
    se = FALSE
  )
#Q2
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_smooth(aes(group = drv),
              se = FALSE)
#Q3
ggplot(mpg, aes(displ, hwy, color = drv)) +
  geom_point() +
  geom_smooth(aes(group = drv),
              se = FALSE)
#Q4
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = drv)) +
  geom_smooth(se = FALSE)

#Q5
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = drv)) +
  geom_smooth(aes(group = drv, linetype = drv),
              se = FALSE)
#Q5
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(colour = drv)) +
  geom_smooth(aes(linetype = drv), se = FALSE)

#Q6
ggplot(mpg, aes(displ, hwy)) +
  geom_point(size = 4, color = "white") +
  geom_point(aes(color = drv))

#위 결과와 상반된 값을 보여줌.
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(size = 4, color = "white")) +
  geom_point(aes(color = drv))

ggplot(diamonds, aes(cut, fill = color)) +
  geom_bar()

ggplot(mpg, aes(cty, hwy)) +
  geom_point()

ggplot(mpg, aes(cty, hwy)) +
  geom_jitter(width = 1)

?geom_jitter

ggplot(mpg, aes(cty, hwy, color = class)) +
  geom_count(position = "jitter")

ggplot(mpg, aes(class, hwy)) +
  geom_boxplot() +
  coord_flip() +
  labs(y = "Highway MPG",
       x = "Class",
       title = "Highway MPG by car class",
       subtitle = "1999-2008",
       caption = "Source: http://fueleconomy.gov")

mpg
table(mpg$cyl)
head(diamonds)
qplot(diamonds$carat)
