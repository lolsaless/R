#----------------
# 데이터 불러오기
#----------------

# Generating date sequence with hourly measurements
start_date <- as.POSIXct("2019-01-01 00:00:00", tz = "UTC")
end_date <- as.POSIXct("2019-03-31 23:00:00", tz = "UTC")
date_sequence <- seq(from = start_date, to = end_date, by = "hour")

# Expanding sample data
n <- length(date_sequence)
data <- data.frame(
    MeasurementDate = date_sequence,
    StationCode = sample(c("A001", "A002", "A003"), n, replace = TRUE),
    SiteName = sample(c("Site1", "Site2", "Site3"), n, replace = TRUE),
    SO2 = runif(n, 0.002, 0.005),
    CO = runif(n, 0.6, 1.0),
    O3 = runif(n, 0.02, 0.05),
    NO2 = runif(n, 0.02, 0.05),
    PM10 = sample(30:60, n, replace = TRUE),
    PM25 = sample(15:35, n, replace = TRUE),
    IntegratedAtmosphericEnvironmentalValue = sample(60:90, n, replace = TRUE),
    VehicleDensity = sample(800:1600, n, replace = TRUE),
    IndustrialActivity = runif(n, 0.4, 0.9),
    Temperature = sample(15:30, n, replace = TRUE)
)
#----------------
# 데이터 구조파악
#----------------
head(data)
tail(data)
dim(data)
table(data$SiteName) #시간대가 달라서, 패널데이터가 아니다. 그렇기 때문에 이것을 나이 같은 질적변수로 봐야한다.


# Load the writexl package
install.packages("writexl"); library(writexl)

# Save the dataset to an Excel file
write_xlsx(data, "AirQualityData.xlsx")

#----------------
# 변수명 바꾸기
#----------------

# 안좋은 방식
names(data)[10] <- c("IAE")
head(data)

# rename을 사용하는 방식
data2 <- rename(data, AAAAA = "IAE")

# 기본 함수, 인덱스를 활용하는 방식
names(data2)[names(data2) == "AAAAA"] <- "IAEV"
head(data2)


#----------------
# 변수 구조파악
#----------------

# Identify the quantitative variables
quantitative_vars <- sapply(data, is.numeric)
quantitative_vars
# Create a dataset with only quantitative variables
quantitative_data <- data[, quantitative_vars]

# Create a dataset with only qualitative variables
qualitative_data <- data[, !quantitative_vars]

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

head(quantitative_data); head(qualitative_data)
#----------------
# 추리통계
#----------------

# 상관분석
res2 <- rcorr(as.matrix(quantitative_data))
print(res2$r, digits = 3)
print(res2$P, digits = 3)

sig <- ifelse(res2$P < 0.05 & !is.na(res2$P), "significant", "")
sig