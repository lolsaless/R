library(foreign) #SPSS파일 불러오기
library(readxl)
library(tidyverse)
setwd("D:/R_coding/Book/Do it R 데이터 분석")
raw_welfare <- read.spss(file ="D:/Koweps_hpc10_2015_beta1.sav",
                         to.data.frame = TRUE)

welfare <- raw_welfare

welfare <- rename(welfare,
                  sex = h10_g3,
                  birth = h10_g4,
                  marriage = h10_g10,
                  religion = h10_g11,
                  income = p1002_8aq1,
                  code_job = h10_eco9,
                  code_region = h10_reg7)

df_wel <- welfare %>% 
  select(sex, birth, marriage, religion, income, code_job, code_region)

class(df_wel$sex)
table(df_wel$sex)

df_wel$sex <- ifelse(df_wel$sex == 1, "male", "female")

table(df_wel$sex)

qplot(df_wel$sex)$stats
boxplot(df_wel$income)$stats

test_df_wel <- df_wel %>% mutate(del_outlier = ifelse(income < 122 | income > 608, NA, income))

boxplot(test_df_wel$del_outlier)$stats

qplot(df_wel$income) + xlim(0, 1000)
summary(df_wel$income)

df_wel %>% filter(income == 0)
df_wel$income <- ifelse(df_wel$income == 0, NA, df_wel$income)
table(is.na(df_wel$income))

sex_income <- df_wel %>% filter(!is.na(income)) %>% 
  group_by(sex) %>% 
  summarise(mean_income = mean(income))

class(df_wel$income)

ggplot(sex_income, aes(sex, mean_income)) + geom_col()


class(df_wel$birth)
table(df_wel$birth)
qplot(df_wel$birth)
table(is.na(df_wel$birth))

df_wel <- df_wel %>% mutate(age = 2015 - birth + 1)
summary(df_wel$age)
qplot(df_wel$age)

age_income <- df_wel %>% filter(!is.na(income)) %>% 
  group_by(age) %>% 
  summarise(mean_income = mean(income))
table(age_income)
head(age_income)

ggplot(age_income, aes(age, mean_income)) +
  geom_line()

df_wel <- df_wel %>% 
  mutate(ageg = ifelse(age < 30, "young",
                       ifelse(age <= 59, "middle", "old")))

table(df_wel$ageg)

ageg_income <- df_wel %>% 
  filter(!is.na(income)) %>% 
  group_by(ageg) %>% 
  summarise(mean_income = mean(income))
ageg_income

ggplot(ageg_income, aes(ageg, mean_income)) +
  geom_col() +
  scale_x_discrete(limits = c("young", "middle", "old"))

sex_income <- df_wel %>% 
  filter(!is.na(income)) %>% 
  group_by(ageg, sex) %>% 
  summarise(mean_income = mean(income))

ggplot(sex_income, aes(ageg, mean_income, color = sex)) +
  geom_col()

ggplot(sex_income, aes(ageg, mean_income, fill = sex)) +
  geom_col()

ggplot(sex_income, aes(ageg, mean_income, group = sex)) +
  geom_col()
