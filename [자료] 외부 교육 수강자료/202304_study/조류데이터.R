#----------------
# 데이터 불러오기
#----------------
if(!require(pacman)) {
    install.packages("pacman")
    library(pacman)
}

p_load("readxl", "tidyverse", "Hmisc")

algae <- read_excel(file.choose(), sheet = 2)

head(algae)
dim(algae)
names(algae)
view(algae)


open_sheet2 <- function() {
    read_excel(file.choose(), sheet = 2)
}
data <- open_sheet2()

data <- data %>% rename(의뢰접수일 = "의뢰\r\n접수일",
                        현장측정_수온 = "현장측정 수온")

names(data)[names(data) == "클로로필A"] <- "클로로필a"
names(data)[names(data)]

?subset
#----------------
# 분석변수의 선정
#----------------

algae <- data %>% select(연도:검체명, 총질소:남조류세포수, 현장측정_수온:세포수)
head(algae)
names(algae)

#----------------
# 변수형태의 변경
#----------------

# 남조류세포수의 질적변화
summary(algae$남조류세포수)
summary(algae["남조류세포수"])
summary(algae[1:100, "남조류세포수"])


ggplot(algae, aes(남조류세포수)) + 
    geom_histogram(binwidth = 10) +
    coord_cartesian(xlim = c(20, 500), ylim = c(0, 200))

#----------------
# 데이터분류
#----------------
algae <- algae %>% mutate(algae_warring = cut(남조류세포수, breaks = c(0, 1000, 10000, 20000, 100000, Inf),
                                              labels = c("정상", "상수관심", "예비", "관심", "경계"),
                                              include.lowest = TRUE))

algae <- algae %>% mutate(algae_warring = ifelse(남조류세포수 <= 1000, "정상",
                                                 ifelse(남조류세포수 < 10000, "상수관심",
                                                        ifelse(남조류세포수 < 20000, "예비",
                                                               ifelse(남조류세포수 < 100000, "관심", "경계")))))

table(algae$algae_warring)
table(is.na(algae$algae_warring))

#----------------
# 변수 구조파악
#----------------
# Identify the quantitative variables
quantitative_vars <- sapply(algae, is.numeric)
quantitative_vars
# Create a dataset with only quantitative variables
quantitative_data <- algae[, quantitative_vars]

# Create a dataset with only qualitative variables
qualitative_data <- algae[, !quantitative_vars]

names(quantitative_data)
names(qualitative_data)

sapply(quantitative_data, table)
sapply(qualitative_data, table)
sapply(quantitative_data, table)
sapply(quantitative_data, function(x) prop.table(table(x)))

sapply(qualitative_data, function(x) length(unique(x)))
#결과는 남조류세포수

