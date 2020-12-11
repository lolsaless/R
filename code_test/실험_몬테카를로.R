library(tidyverse)
tibble(
  x=runif(n=10000, min=-1, max=1),
  y=runif(n=10000, min=-1, max=1),
  in_circle=ifelse(x^2+y^2<=1, 1, 0)
) %>% 
  ggplot(aes(x=x,y=y, color=as_factor(in_circle))) +
  geom_point() +
  scale_color_manual(values = c('red', 'black')) +
  coord_equal() +
  guides(color=F)

tibble(
  x=runif(n=100000, min=-1, max=1),
  y=runif(n=100000, min=-1, max=1),
  in_circle=ifelse(x^2+y^2<=1, 1, 0)
) %>%
  ggplot(aes(x=x, y=y, color=as_factor(in_circle))) +
  geom_point() +
  scale_color_manual(values=c('#cdcdcd', '#79c3d6')) +
  coord_equal() +
  guides(color=FALSE)
