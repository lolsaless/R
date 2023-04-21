outlier <- data.frame(sex = c(1, 2, 1, 3, 2, 1),
                      score = c(5, 4, 3, 4, 2, 6))
outlier

table(outlier$sex)
table(outlier$score)

outlier$sex <- ifelse(outlier$sex == 3, NA, outlier$sex)
outlier
outlier$score <- ifelse(outlier$score > 5, NA, outlier$score)
outlier

outlier %>% filter(!is.na(sex) & !is.na(score)) %>% 
  group_by(sex) %>% 
  summarise(mean_score = mean(score))

boxplot(mpg$hwy)
boxplot(mpg$hwy)$stats
#위에서 아래 순으로, 아래쪽 극단치 경계
#1사분위수
#중앙값
#3사분위수
#위쪽 극단치 경계
#이 값을 통해 13~37을 벗어나면 극다니로 분류된다.

table(is.na(mpg$hwy))
df_mpg <- mpg

df_mpg$hwy <- ifelse(mpg$hwy < 12 | mpg$hwy > 37, NA, mpg$hwy)

table(is.na(df_mpg$hwy))
 
df_mpg %>% group_by(drv) %>% 
  summarise(mean_hwy = mean(hwy, na.rm = TRUE))

df_mpg <- mpg
df_mpg[c(10, 14, 58, 93), "drv"] <- "K"
df_mpg[c(29, 43, 129, 203), "cty"] <- c(3, 4, 39, 42)

table(df_mpg$drv)

df_mpg$drv <- ifelse(df_mpg$drv %in% c(4, "f", "r"), df_mpg$drv, NA)
table(df_mpg$drv)
table(is.na(df_mpg$drv))

boxplot(df_mpg$cty)
boxplot(df_mpg$cty)$stats

df_mpg$cty <- ifelse(df_mpg$cty < 9 | df_mpg$cty > 26, NA, df_mpg$cty)

boxplot(df_mpg$cty)
table(is.na(df_mpg$cty))

df_mpg %>% filter(is.na(cty))
df_mpg %>% filter(cty == "NA")

df_mpg %>% filter(!is.na(drv) & !is.na(cty)) %>% 
  group_by(drv) %>% 
  summarise(mean_cty = mean(cty))

df_mpg %>%
  group_by(drv) %>% 
  summarise(mean_cty = mean(cty, na.rm = TRUE)) %>% 
  filter(!is.na(drv))
