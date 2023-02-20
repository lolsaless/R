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

#test
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

ggplot(sex_income, aes(ageg, mean_income, fill = sex)) +
  geom_col(position = "dodge")

sex_age <- df_wel %>% filter(!is.na(income)) %>% 
  group_by(age, sex) %>% 
  summarise(mean_income = mean(income))

head(sex_age)

ggplot(sex_age, aes(age, mean_income, color = sex)) +
  geom_line()

class(df_wel$code_job)
table(df_wel$code_job)

list_job <- read_excel("D:/Koweps_Codebook.xlsx", col_names = TRUE, sheet = 2)
head(list_job)
dim(list_job)

df_wel <- left_join(df_wel, list_job, by = "code_job")

df_wel %>% 
  filter(!is.na(code_job)) %>% 
  select(code_job, job) %>% 
  head(10)
is.na(df_wel$job)
table(is.na(df_wel$job))

job_income <- df_wel %>% filter(!is.na(income) & !is.na(job)) %>% 
  group_by(job) %>% 
  summarise(mean_income = mean(income))

ggplot(job_income, aes(job, mean_income)) +
  geom_col()

top10 <- job_income %>% 
  arrange(desc(mean_income)) %>% 
  head(10)

top10
ggplot(top10, aes(reorder(job, mean_income), mean_income)) +
  geom_col() +
  coord_flip()
bottom10 <- job_income %>% 
  arrange(desc(mean_income)) %>% 
  tail(10)
ggplot(bottom10, aes(reorder(job, -mean_income), mean_income)) +
  geom_col() +
  coord_flip()

#성별 직업 빈도
job_male <- df_wel %>% 
  filter(!is.na(job) & sex == "male") %>% 
  group_by(job) %>% 
  summarise(cnt = n()) %>% 
  arrange(desc(cnt)) %>% 
  head(10)

job_male

job_female <- df_wel %>% 
  filter(!is.na(job) & sex =="female") %>% 
  group_by(job) %>% 
  summarise(cnt = n()) %>% 
  arrange(desc(cnt)) %>% 
  head(10)

job_female

#종교 유무에 따른 이혼율
table(df_wel$marriage)
table(df_wel$religion)

df_wel <- df_wel %>% mutate(group_marriage = ifelse(marriage == 1, "marriage",
                                                    ifelse(marriage == 3, "divorce", NA)))
df_wel <- df_wel %>% mutate(yn_religion = ifelse(religion == 1, "yes", "no"))

table(df_wel$group_marriage)  
table(is.na(df_wel$group_marriage))

qplot(df_wel$group_marriage)

religion_marriage <- df_wel %>% 
  filter(!is.na(group_marriage)) %>% 
  group_by(yn_religion, group_marriage) %>% 
  summarise(cnt = n()) %>% 
  mutate(tot_group = sum(cnt),
         pct = round(cnt/tot_group*100, 1))
religion_marriage

#이혼 추출
divorce <- religion_marriage %>% 
  filter(group_marriage == "divorce") %>% 
  select(yn_religion, pct)
divorce

df_wel %>% 
  filter(!is.na(group_marriage)) %>% 
  count(ageg, group_marriage)


ageg_marriage <- df_wel %>% 
  filter(!is.na(group_marriage)) %>% 
  group_by(ageg, group_marriage) %>% 
  summarise(cnt = n()) %>% 
  mutate(tot_group = sum(cnt),
         pct = round(cnt/tot_group*100, 1))

ageg_divorce <- ageg_marriage %>% 
  filter(ageg %in% c("middle", "old") & group_marriage == "divorce") %>% 
  select(ageg, pct)

ggplot(ageg_divorce, aes(ageg, pct)) + geom_col()

ageg_religion_divorce <- df_wel %>% 
  filter(!is.na(group_marriage) & ageg != "young") %>% 
  group_by(ageg, yn_religion, group_marriage) %>% 
  summarise(n = n()) %>% 
  mutate(tot_group = sum(n),
         pct = round(n/tot_group*100, 1))
ageg_religion_divorce

df_divorce <- ageg_religion_divorce %>% 
  filter(group_marriage == "divorce") %>% 
  select(ageg, yn_religion, pct)
df_divorce

ggplot(df_divorce, aes(ageg, pct, fill = yn_religion)) +
  geom_col(position = "dodge")

#지역별 연령대 비율
class(df_wel$code_region)
table(df_wel$code_region)

list_region <- data.frame(code_region = c(1:7),
                          region = c("서울",
                                     "수도권(인천/경기)",
                                     "부상/경남/울산",
                                     "대구/경북",
                                     "대전/충남",
                                     "강원/충북",
                                     "광주/전남/전북/제주도"))
list_region

df_wel <- left_join(df_wel, list_region, by = "code_region")
df_wel %>% 
  select(code_region, region) %>% 
  head

region_ageg <- df_wel %>% 
  group_by(region, ageg) %>% 
  summarise(n = n()) %>% 
  mutate(tot_group = sum(n),
         pct = round(n/tot_group*100, 2))
head(region_ageg)

df_wel %>% count(region)

ggplot(region_ageg, aes(region, pct)) + geom_col()
ggplot(region_ageg, aes(region, pct, fill = ageg)) +
  geom_col() +
  coord_flip()

#노년층 비율 높은 순으로 막대 정렬
list_order_old <- region_ageg %>% 
  filter(ageg == "old") %>% 
  arrange(pct)
list_order_old

#지역명 순서 변수 만들기
order <- list_order_old$region
order

ggplot(region_ageg, aes(region, pct, fill = ageg)) +
  geom_col() +
  coord_flip() +
  scale_x_discrete(limits = order)

#연령대 순으로 막대 색 나열하기
class(region_ageg$ageg)
levels(region_ageg$ageg)

region_ageg$ageg <- factor(region_ageg$ageg,
                           levels = c("old", "middle", "young"))
class(region_ageg$ageg)
levels(region_ageg$ageg)

ggplot(region_ageg, aes(region, pct, fill = ageg)) +
  geom_col() +
  coord_flip() +
  scale_x_discrete(limits = order)
  