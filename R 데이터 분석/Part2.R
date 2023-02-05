history <- c(90, 80, 60, 70)
math <- c(50, 60, 100, 20)

df_midterm <- data.frame(history, math)

class <- c(1,1,2,2)

df_midterm2 <- add_column(df_midterm, class)

df_midterm2

tomato <- read.csv("~/Documents/GitHub/R_coding/3. book R for everyone/Tomato First.csv", header = TRUE, sep = "," )

install.packages("readxl")

View(tomato)

tomato
library(tidyverse)

tomato <- as.tibble(tomato)
class(tomato)
tomato

mean(tomato$Sweet)

head(tomato)
?read.csv


head(tomato, 10)
unique(tomato$Round)
tail(tomato)

str(tomato)
a <- summary(tomato)
a
b <- as.data.frame(a)
b


df_raw <- data.frame(var1 = c(1,2,1),
                     var2 = c(2,3,2))
df_new <- df_raw

df_new <- rename(df_new, v2 = var2)
df_new


n_tomato <- rename(tomato, No.1 = Round)
head(n_tomato)

df_mpg <- ggplot2::mpg
ndf_mpg <- rename(df_mpg, city = cty, highway = hwy)
head(ndf_mpg)


#파생변수만들기
n_tomato <- mutate(tomato,
                   SA = Sweet / Acid,
                   CT = Color / Texture,
                   .before = 1)
n_tomato


mpg
aaa<- mutate(mpg,
                 Total = (cty + hwy)/2,
                 .before = 1)
aaa
head(df_mpg)

aa <- mutate(mpg,
       a = cty)

df_mpg <- mutate(mpg,
                 Total = (cty + hwy)/2,
                 .before = 1)
head(df_mpg)

df_mpg <- mutate(df_mpg,
                 Test = ifelse(Total >= 20, "pass", "fail"))
head(df_mpg)

table(df_mpg$Test)

qplot(df_mpg$Test)


df_mpg <- mutate(df_mpg,
                 Grade = ifelse(Total >= 30, "A",
                                ifelse(Total >= 20, "B", "C")))
head(df_mpg)
head(df_mpg, 20)

table(df_mpg$Grade)


midwest
str(midwest)
dim(midwest)
n_midwest <- midwest

n_midwest <- rename(n_midwest, total = poptotal, asian = popasian)
head(n_midwest)
colnames(n_midwest)

n_midwest <- mutate(n_midwest,
                    per_at = (asian / total) * 100,
                    .before = 4)
colnames(n_midwest)
head(n_midwest)
ggplot(n_midwest, aes(county, per_at)) +
  geom_point()
############# 잘못함

n_midwest <- mutate(n_midwest,
                    per_at_ave = mean(per_at))
head(n_midwest)

n2_midwest <- mutate(n_midwest,
                     size = ifelse(n_midwest$per_at_ave > mean(n_midwest$per_at),
                                   "large",
                                   "small"))
table(n2_midwest$size)
mean(n_midwest$per_at)

n3_m <- mutate(n_midwest,
               size = ifelse(per_at_ave > mean(per_at), "large", "small"))
n3_m
table(n3_m$size)
###### 잘못함


n_m <- rename(midwest, total = poptotal, asian = popasian)
colnames(n_m)

n_m2 <- mutate(n_m,
               ratio = (asian / total) * 100,
               .before = 1)
colnames(n_m2)
View(n_m2)

n_m3 <- mutate(n_m2,
               test = ifelse(ratio > mean(ratio),
                             "large",
                             "small"))
table(n_m3$test)

#chapter 5

mpg
mpg %>% filter(manufacturer == "audi")

mpg %>% filter(model == "a4")

?filter

mpg %>% filter((model != "a4"))

a <- mpg %>% filter(displ %in% c(4,5))
a
a <- mpg %>% filter(displ == 4)

b <- mpg %>% filter(displ == 5)

mean(a$hwy)
mean(b$hwy)

audi <- mpg %>% filter(manufacturer == "audi") %>% 
  select(cty) %>% summarise(mean_audi = mean(cty))

toyota <- mpg %>% filter(manufacturer == "toyota") %>% 
  select(cty)
mean(audi$cty)
mean(toyota$cty)

car_ave <- mpg %>% filter(manufacturer %in% c("chevrolet", "ford", "honda")) %>% 
  select(hwy)

mean(car_ave$hwy)

mpg %>% filter(manufacturer %in% c("chevrolet", "ford", "honda")) %>% 
  select(hwy)


new_mpg <- mpg %>% select(class, cty)
new_mpg %>% filter(class == "suv") %>% 
  mean(cty)

mpg %>% arrange(cty)


mpg %>% arrange(desc(cty))

mpg %>% select(manufacturer) %>% 
  filter("audi")

mpg %>% select(manufacturer) %>% 
  filter(manufacturer == "audi")


mpg %>% filter(manufacturer == "audi") %>% 
  arrange(desc(hwy)) %>% head(5)

f_mpg <- mpg %>% mutate(.,
                        total = hwy + cty,
                        .before = 1)
f_mpg <- f_mpg %>% mutate(.,
                          t_ave = total/2,
                          .before = 1)
f_mpg %>% arrange(desc(t_ave)) %>% head(3)

mpg %>% mutate(.,
               total = hwy + cty,
               t_ave = total/2,
               .before = 1) %>%
  arrange(desc(t_ave)) %>% head(3)


mpg %>% filter(manufacturer == "audi") %>% 
  select(cty) %>% summarise(mean_audi = mean(cty))


mpg %>% group_by(class) %>% 
  summarise(class_cty = mean(cty)) %>% 
  arrange(desc(class_cty))

mpg %>% group_by(manufacturer) %>% 
  summarise(best_hwy = mean(hwy)) %>% 
  arrange(desc(best_hwy)) %>% head(3)

mpg %>% filter(class == "compact") %>% 
  group_by(manufacturer) %>% 
  summarise(compact_count = n()) %>% 
  arrange(desc(compact_count))


head(mpg)

fuel <- data.frame(fl = c("c", "d", "e", "p", "r"),
                   price_fl = c(2.35, 2.38, 2.11, 2.76, 2.22),
                   stringsAsFactors = FALSE)
fuel

mpg %>% left_join(., fuel, by = "fl") %>% 
  group_by(manufacturer, fl) %>% 
  summarise(ave_fl = mean(price_fl))

mpg %>% left_join(., fuel, by = "fl") %>% select(model, fl, price_fl) %>% head(5)
  
