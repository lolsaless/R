library(tidyverse)
library(readxl)

data_DDG <- read_xlsx("대전광역시_대덕구.xlsx", col_names = TRUE)
data_DG <- read_xlsx("대전광역시_동구.xlsx", col_names = TRUE)
identical(colnames(data_DDG), colnames(data_DG))
data_bind <- na.omit(rbind(data_DDG, data_DG))
table(!is.na(data_bind$`피해운전자 연령`))

colnames(data_bind)
data_bind %>% group_by(사고내용) %>% 
  summarise(total = sum(경상자수))
#data_bind %>% count(.$사고내용)

data_grade <- data_bind %>% mutate(age = as.numeric(substr(`피해운전자 연령`,1,2)),
                                   age_grade = ifelse(age < 30, 1,
                                                      ifelse(age < 40, 2,
                                                             ifelse(age < 50, 3, 4))))
dim(data_grade)

a <- data_grade %>% select(사고내용, age_grade) %>% 
  group_by(사고내용, age_grade) %>% 
  summarise(n = n()) %>% 
  na.omit(.) %>% 
  arrange(desc(n))

sum(a$n)

data_grade %>% filter(사고내용 == "중상사고") %>% 
  select(시군구, 사고내용, 중상자수) %>% 
  group_by(시군구) %>% 
  summarise(n = max(중상자수)) %>% 
  arrange(desc(n)) %>% 
  head(5)

data_grade %>% filter(사고내용 == "중상사고", 
                      중상자수 == max(중상자수)) %>% 
  select(시군구)

