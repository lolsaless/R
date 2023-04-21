library(tidyverse)
library(modelr)
options(na.action = na.warn)

sim1
ggplot(sim1, aes(x, y)) +
    geom_point()

models_test <- tibble(
    a1 = runif(250, -20, 40),
    a2 = runif(250, -5, 5)
)

ggplot(sim1, aes(x, y)) +
    geom_abline(
        aes(intercept = a1, slope = a2),
        data = models_test, alpha = 1/4
    ) +
    geom_point()

#모델 만들기
model1 <- function(a, data) {
    a[1] + data$x * a[2]
}
view(sim1)
model1(c(7, 1.5), sim1)

measure_distance <- function(mod, data) {
    diff <- data$y - model1(mod, data)
    sqrt(mean(diff ^ 2))
}

measure_distance <- function(mod, data) {
    diff <- data$y - model1(mod, data)
    print(diff)
    sqrt(mean(diff ^ 2))

}

measure_distance(c(7, 1.5), sim1)

sim1_dist <- function(a1, a2) {
    measure_distance(c(a1, a2), sim1)
}

models_test

models_test <- models_test %>% 
    mutate(dist = map2_dbl(a1, a2, sim1_dist))
models_test


ggplot(sim1, aes(x, y)) +
    geom_point(size = 2, color = "grey30") +
    geom_abline(
        aes(intercept = a1, slope = a2, color = -dist),
        data = filter(models_test, rank(dist) <= 10)
    )
