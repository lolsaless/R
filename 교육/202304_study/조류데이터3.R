# ------------------------------
# 패키지 로드 및 데이터 불러오기
# ------------------------------
if (!require(pacman)) {install.packages("pacman")
    library(pacman)}
pacman::p_load("readxl", "ggplot2", "Hmisc", "dplyr", "stargazer", "report")

# (추가) 로컬파일에서 데이터 로드하기: 로컬컴퓨터에 데이터 파일이 있는지 사전확인
df_loc = file.choose()
#incheon0427_local <- read_excel(file.choose())
algae_local <- read_excel(df_loc,sheet=2)
#df_loc
data <- algae_local

# ------------------------------
# 데이터 구조파악
# ------------------------------
#head(incheon0427)
head(data)
dim(data)
names(data)

# ------------------------------
# 변수명 바꾸기
# ------------------------------
# 변수 이름 변경
names(data)[names(data) == "의뢰\r\n접수일"] <- "의뢰접수일"
names(data)[names(data) == "현장측정 수온"] <- "현장측정_수온"
head(data)

# ------------------------------
# 분석변수의 선정
# ------------------------------
names(data)
#df = subset(data,select=c(q1,q3,q84,q48,q10,q11,q12))
df = subset(data,select=-c(채수시각,총유기탄소량,세포수,우점종,Microcystis,Anabaena,Oscillatoria,Aphanizomenon))
#names(df)
head(df)
names(df)

# ------------------------------
# 변수형태 변경
# ------------------------------

# 남조류세포수의 질적변수화
summary(df$남조류세포수)
#summary(df["남조류세포수"])

# # 히스토그램 그리기
ggplot(df, aes(남조류세포수)) + 
    geom_histogram(binwidth = 100) +
    coord_cartesian(xlim = c(0, 10000), ylim = c(0, 200))

df$남조류세포수_cat <- cut(df$남조류세포수, 
                     breaks = c(0, 1000, 10000, 20000, 100000, Inf), 
                     labels = c("정상", "상수_관심", "예비", "관심", "경계"),
                     include.lowest = TRUE)
table(df$남조류세포수_cat)

# ------------------------------
# 변수 구조파악
# ------------------------------
# Identify the quantitative variables
#is.numeric(df$q1)
quantitative_vars <- sapply(df, is.numeric)

# Create a dataset with only quantitative variables
quantitative_data <- df[, quantitative_vars]

# Create a dataset with only qualitative variables
qualitative_data <- df[, !quantitative_vars]

names(quantitative_data); names(qualitative_data)

head(quantitative_data); head(qualitative_data)

sapply(qualitative_data, function(x) length(unique(x)))


# ------------------------------
# 단순회귀 분석 연습
# ------------------------------

# 회귀 모델 적합
model <- lm(남조류세포수 ~ 현장측정_수온,data=df)
# 결과 출력
summary(model)

# ------------------------------
# 다중회귀 분석 연습
# ------------------------------

# Specify independent and dependent variables
independent_vars <- c("현장측정_수온", "총인")
dependent_var <- "남조류세포수"
# Create the formula for the regression model
formula <- as.formula(paste(dependent_var, "~", paste(independent_vars, collapse = " + ")))
# Fit the regression model
mod1 <- lm(formula, data = df)
# 결과 출력
summary(mod1)


# 데이터 표준화
df_scaled <- df %>%
    mutate(across(all_of(c(independent_vars, dependent_var)), scale))
ex=cbind(df$남조류세포수,df_scaled$남조류세포수)
ex[100:120, ]


# 표준화된 데이터로 회귀 모델 생성
#formula <- as.formula(paste(dependent_var, "~", paste(independent_vars, collapse = " + ")))
mod1_scaled <- lm(formula, data = df_scaled)

# 표준화 결과 출력
summary(mod1_scaled)

# 결과정리
stargazer(mod1, mod1_scaled, type = "text", report = "vct*", star.cutoffs = c(0.05, 0.01, 0.001),
          column.labels = c("coef", "std coef"), single.row = TRUE)

stargazer(mod1, mod1_scaled, type = "text", report = "vct*", star.cutoffs = c(0.05, 0.01, 0.001),
          column.labels = c("coef", "std coef"), out = file.choose(), single.row = TRUE)

report(mod1_scaled)