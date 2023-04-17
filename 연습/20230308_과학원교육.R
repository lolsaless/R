english <- c(90, 80, 60, 70)
math <- c(50, 60, 100, 20)

df_midterm <- data.frame(english, math)
df_midterm <- df_midterm %>% mutate(class = c(1, 1, 2, 2))

csv_exam <- read.csv("csv_exam.csv")
mean(as.numeric(csv_exam[csv_exam$class == 2, "math"]))

library(tidyverse)

csv_exam %>% filter(class == 2) %>% summarise(m = mean(math))

fruit <- data.frame(제품 = c("사과", "딸기", "수박"),
                    가격 = c(1800, 1500, 3000),
                    판매량 = c(24, 38, 13))

fruit %>% summarise(가격평균 = mean(가격),
                    판매량평균 = mean(판매량))

mean(fruit$가격)
mean(fruit$판매량)
summary(fruit)

fruit <- fruit %>% rename("prod" = 제품,
                          "price" = 가격,
                          "n" = 판매량)
fruit

a <- (csv_exam$math + csv_exam$english +csv_exam$science)/3

data(mpg)

mpg <- mpg %>% mutate(total = (cty + hwy)/2,
               .before = 1)
hist(mpg$total)

mpg <- mpg %>% mutate(test = ifelse(total >= 20, "pass", "fail"))

mpg %>% group_by(test, manufacturer) %>% 
  summarise(mean_cty = mean(cty)) %>% 
  arrange(desc(mean_cty))

table(mpg$manufacturer)
unique(mpg$manufacturer)


df_mid <- midwest
str(df_mid)


df_mid <- df_mid %>% rename(total = poptotal,
                            asian = popasian)

df_mid <- df_mid %>% mutate(total_asian = (asian/total)*100)

hist(df_mid$total_asian)
mean(df_mid$total_asian)

ggplot(df_mid, aes(state, total_asian)) +
  geom_col()

df_mid <- df_mid %>% mutate(test = ifelse(total_asian >= mean(total_asian),
                                          "large",
                                          "small"))

df_mid
view(df_mid)
table(df_mid$test)
qplot(df_mid$test)

#