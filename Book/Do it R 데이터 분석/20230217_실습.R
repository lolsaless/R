library(readxl)
library(tidyverse)
df_exam <- read_excel("excel_exam.xlsx", col_names = TRUE)
df_exam

mean(df_exam$english)
mean(df_exam$math)
mean(df_exam$science)

df_exam %>% select(math, english, science) %>% 
  summarise(mean_math = mean(math),
            mean_english = mean(english),
            mean_sicence = mean(science))

df_raw <- data.frame(var1 = c(1,2,3),
                     var2 = c(2,3,2))
df_raw

rename(df_raw, v2 = var2)
df_raw
df_new <- rename(df_raw, v2 = var2)
df_new

df_mpg <- mpg

df_mpg <- df_mpg %>% rename(., c(city = cty, highway = hwy))

df_mpg <- df_mpg %>% mutate(total = (city+highway)/2,
                            .before = 1)
df_mpg <- df_mpg %>% mutate(test = ifelse(total >= 20, "pass", "fail"),
                            .before = 2)
df_mpg

table(df_mpg$test)
table(df_mpg$manufacturer)

df_mpg <- df_mpg %>% mutate(grade = ifelse(total >= 30, "A",
                                            ifelse(total >= 20, "B", "C")),
                            .before = 3)
table(df_mpg$grade)
tail(df_mpg)
view(df_mpg)
ggplot(df_mpg, aes(total)) +
  geom_histogram()


df_midwest <- midwest
str(midwest)
colnames(midwest)
df_midwest %>% count(cut_width(poptotal, 1000))

df_midwest <- df_midwest %>% rename(., c(total = poptotal, asian = popasian))
str(df_midwest)

df_midwest <- df_midwest %>% mutate(asian_ratio = (asian/total)*100,
                                    .before = 1)
ggplot(df_midwest, aes(asian_ratio)) +
  geom_histogram()

df_midwest %>% mean(.$asian_ratio)

mean(df_midwest$asian_ratio)

df_midwest <- df_midwest %>% mutate(test = ifelse(asian_ratio >= mean(asian_ratio),
                                                  "large", "small"),
                                    .before = 1)
table(df_midwest$test)

df_exam %>% filter(class == 1)

df_exam %>% filter(class %in% c(1, 3, 5))

mpg %>% group_by(manufacturer) %>% 
  summarise(aaa = mean(hwy))

#displ 4이하인 자동차와 5이상인 자동차의 hwy 평균 연비 구하기

mpg %>% select(manufacturer, cty) %>% 
  filter(manufacturer == "audi" | manufacturer == "toyota") %>% 
  group_by(manufacturer) %>% 
  summarise(means = mean(cty))

mpg %>% select(class, cty) %>% 
  filter(class == "suv" | class == "compact") %>% 
  group_by(class) %>% 
  summarise(means = mean(cty))

mpg %>% select(model, cty, hwy) %>% mutate(total = cty + hwy,
               ave = total/2) %>% 
  arrange(desc(ave)) %>% 
  head(3)

mpg %>% mutate(grade = ifelse(displ >= 5, "A", "B")) %>% 
  group_by(grade) %>% 
  summarise(means = mean(hwy))

mpg %>% filter(class == "suv") %>% 
  group_by(manufacturer) %>% 
  summarise(cty_mean = mean(cty),
            hwy_mean = mean(hwy)) %>% 
  arrange(desc(cty_mean)) %>% head(5)

mpg %>% select(class, cty) %>% 
  group_by(class) %>% 
  summarise(mean_cty = mean(cty)) %>% 
  arrange(desc(mean_cty))

mpg %>% group_by(manufacturer) %>% 
  summarise(mean_hwy = mean(hwy)) %>% arrange(desc(mean_hwy)) %>% 
  head(3)

mpg %>% filter(class == "compact") %>% 
  group_by(manufacturer) %>% 
  summarise(cnt = n())
table(mpg$class)

fuel <- data.frame(fl = c("c", "d", "e", "p", "r"),
                   price_fl = c(2.35, 2.38, 2.11, 2.76, 2.22))
fuel

mpg %>% left_join(., fuel, by = "fl") %>% filter(model == "altima") %>% 
  select(model, fl, price_fl) %>% 
  group_by(model) %>% 
  summarise(mean_price = mean(price_fl))

mpg %>% filter(model == "altima")

df <- data.frame(sex = c("M", "F", NA, "M", "F"),
                 score = c(5, 4, 3, 4, NA))
df                 

!is.na(df)
table(is.na(df))

df %>% filter(!is.na(score))

df_exam[c(3, 8, 15), "math"] <- NA
df_exam %>% summarise(mean_math = mean(math, na.rm = TRUE))

table(is.na(df_exam))

a_mpg <- mpg
a_mpg[c(5, 65, 124, 131, 153, 212), "hwy"] <- NA
a_mpg

a_mpg %>% filter(!is.na(hwy)) %>% 
  group_by(drv) %>% 
  summarise(mean_hwy = mean(hwy))
