library(tidyverse)
library(reprex)
diet <- read.csv("diet.csv", header = TRUE)
diet <- na.omit(diet)
reprex()

diet %>% filter(!is.na(gender))


diet %>% select(gender, Height, weight6weeks) %>% 
  filter(Height >= 170 & gender == 1) %>% 
  arrange(desc(weight6weeks)) %>% 
  head(5)

diet_bmi <- diet %>% mutate(BMI = weight6weeks/(Height^2)*10000)

diet_bmi_grade <- diet_bmi %>% mutate(grade = ifelse(BMI >= 25, "비만",
                                                     ifelse(BMI >= 23, "과체중",
                                                            ifelse(BMI > 18.5, "정상", "저체중"))))

diet_bmi_grade %>% group_by(gender, grade) %>%
  summarise(BMI_n = n(),
            BMI_avg = mean(BMI),
            BMI_sd = sd(BMI))


apt <- as_tibble(apt)
list_apt <- strsplit(apt$시군구, split = " ")

for(i in 1:nrow(apt)) {
  apt[i, "시"] = strsplit(apt$시군구[i], split = " ")[[1]][1]
  apt[i, "구"] = strsplit(apt$시군구[i], split = " ")[[1]][2]
  apt[i, "동"] = strsplit(apt$시군구[i], split = " ")[[1]][3]
}

apt %>% mutate(si = strsplit(시군구, split = " "))



head(apt)


apt <- apt %>% mutate(year = substr(계약년월, 1, 4),
                      month = substr(계약년월, 5, 6))

head(apt)

apt %>% group_by(구) %>% 
  summarise(money = mean(`거래금액(만원)`))

apt %>% group_by(구) %>% 
  summarise(n = n(),
            n_m = mean(`거래금액(만원)`)) %>% 
  arrange(desc(n))
