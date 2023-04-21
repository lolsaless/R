data(mtcars)
data(diamonds)

dia <- diamonds

break1 <- cut(dia$carat, seq(0))


dia %>% count(cut_width(carat, 0.5))


mtcars$cyl <- as.character(mtcars$cyl)

