# ------------------------------
# 패키지 로드 및 데이터 불러오기
# ------------------------------

if (!require(pacman)) {
    install.packages("pacman")
    library(pacman)
}
pacman::p_load("writexl", "ggplot2", "Hmisc")

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
head(data)
tail(data)

table(data$StationCode)

# Load the writexl package
#install.packages("writexl"); library(writexl)

# Save the dataset to an Excel file
write_xlsx(data, "AirQualityData.xlsx")

# ------------------------------
# 데이터 구조파악
# ------------------------------
#head(incheon0427)
head(data)
dim(data)
names(data)

table(data$SiteName)

# ------------------------------
# 변수명 바꾸기
# ------------------------------
# 변수 이름 변경
#names(df)[names(df) == "IntegratedAtmosphericEnvironmentalValue"] <- "IAEV"
names(data)[names(data) == "IntegratedAtmosphericEnvironmentalValue"] <- "IAEV"
#names(data)[10] <- "IAEV"

# ------------------------------
# 변수 구조파악
# ------------------------------
# Identify the quantitative variables
#is.numeric(df$q1)
quantitative_vars <- sapply(data, is.numeric)

# Create a dataset with only quantitative variables
quantitative_data <- data[, quantitative_vars]

# Create a dataset with only qualitative variables
qualitative_data <- data[, !quantitative_vars]

names(quantitative_data); names(qualitative_data)

head(quantitative_data); head(qualitative_data)

sapply(qualitative_data, function(x) length(unique(x)))