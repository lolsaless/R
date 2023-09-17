library(ggplot2)
library(tidyverse)
library(Hmisc)
library(lme4)
library(nlme)


lm1 <- lm(Reaction ~ Days, sleepstudy)
summary(lm1)

sleepstudy$res <- residuals(lm1)
sleepstudy$fit <- predict(lm1)

ggplot(sleepstudy, aes(x=fit, y=res)) +
  geom_point() +
  geom_smooth()
## `geom_smooth()` using method = 'loess'

#SET color and size to make dots stand out more
ggplot(sleepstudy, aes(x=Subject, y=res)) +
  geom_point() +
  stat_summary(color="red", size=1) 
## No summary function supplied, defaulting to `mean_se()