#----------------
# 데이터 불러오기
#----------------
# if (!require(readxl))
# {install.packages("readxl")
#     library(readxl)}
# url <- "https://github.com/HakJun-Song/class/blob/master/incheon0427.xlsx?raw=true"
# destfile <- "incheon0427.xlsx"
# curl::curl_download(url, destfile)
# incheon0427 <- read_excel(destfile)
# 
# head(incheon0427)

if (!require(pacman)) {
    install.packages("pacman")
    library(pacman)
}

p_load("tidyverse", "forecast", "Hmisc")

# -------------
# 제목설정
# -------------

add_comment <- function(title) {
    cat("#----------------\n")
    cat(paste0("# ", title, "\n"))
    cat("#----------------\n")
}

add_comment("데이터 불러오기")
add_comment("데이터 구조파악")

# (추가) 로컬파일에서 데이터 로드하기: 로컬컴퓨터에 데이터 파일이 있는지 사전확인
incheon0427_local <- read_excel(file.choose())

#----------------
# 데이터 구조파악
#----------------
# head(incheon0427)
head(incheon0427_local)

dim(incheon0427_local)
str(incheon0427_local)
names(incheon0427_local)

#----------------
# 변수 구조파악
#----------------
df <- subset(incheon0427_local,
             select = c(q1, q3, q84, q10, q11, q12, q48)
             )

#----------------
# 변수의 형태변경
#----------------
df <- df %>% mutate(q1_cat = ifelse(q1 == 1, "남자", "여자"),
                    .before = 1)

df <- df %>% mutate(q3_cat = cut(df$q3, breaks = c(0, 1, 2, 3, 4, 5),
                                 labels = c("10대", "20대", "30대", "40대", "50대")),
                    .after = 1)


df <- df %>% mutate(q84_cat = cut(df$q84, breaks = c(0, 1, 2, 3, 4),
                                  labels = c("고졸이하", "전문대", "대학교", "대학원")),
                    .after = 2)

table(df$q1_cat)
lapply(df, table)



#----------------
# 변수 구조파악
#----------------
# Identify the quantitative variables
quantitative_vars <- sapply(df, is.numeric)
quantitative_vars
# Create a dataset with only quantitative variables
quantitative_data <- df[, quantitative_vars]

# Create a dataset with only qualitative variables
qualitative_data <- df[, !quantitative_vars]

names(quantitative_data)
names(qualitative_data)

sapply(quantitative_data, table)
sapply(qualitative_data, table)
sapply(quantitative_data, table)
sapply(quantitative_data, function(x) prop.table(table(x)))

sapply(qualitative_data, function(x) length(unique(x)))

sapply(qualitative_data, function(x) {
    x <- as.character(x)
    barplot(table(x))
})

#apply function사용에 관하여, 둘 다 같은 결과 보임
sapply(qualitative_data, function(x) length(unique(x)))

sapply(qualitative_data, function(x) {
    length(unique(x))
})

# 해결해보기
# sapply(qualitative_data, function(x) {
#     x <- as.data.frame(x)
#     ggplot(aes(x, fill = variable)) +
#         geom_density()
# })
# #----------------
# 양적변수 기초분석
#----------------
summary(quantitative_data)
sapply(quantitative_data, function(x) {
    x <- as.character(x)
    boxplot(table(x))
})

# 해결해보기
# df$df_eco_mean <- rowMeans(df[, c("q10", "q11", "q12")])
# df %>% summarise(eco_mean = rowsum("q10", "q11", "q12"))
# rowMeans(df[, c("q10", "q11", "q12")])

#----------------
# 추리통계
#----------------

# 상관분석
res2 <- rcorr(as.matrix(quantitative_data))
print(res2$r, digits = 3)
print(res2$P, digits = 3)

sig <- ifelse(res2$P < 0.05 & !is.na(res2$P), "significant", "")
sig
