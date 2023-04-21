if (!require("dplyr")) {
    install.packages("dplyr")
}

# Load the required packages
library(dplyr)

# Assuming combined_data is the data frame containing the combined data

# Function to check if a row contains any of the specified keywords in any column
contains_keywords <- function(row) {
    any(grepl("정제수|마그네슘|칼슘|칼륨", row, ignore.case = TRUE))
}

combined_data <- 혼합음료_리스트

# Select rows containing the specified keywords in any column
filtered_data <- combined_data %>%
    filter(apply(., 1, contains_keywords))

# Check the filtered data
head(filtered_data)



# Install the required packages if you haven't already
if (!require("dplyr")) {
    install.packages("dplyr")
}

# Load the required packages
library(dplyr)

# Assuming combined_data is the data frame containing the combined data

# Function to check if a column contains any of the specified keywords
contains_keywords <- function(column) {
    any(grepl("먹는물|정제수|마그네슘|칼슘|칼륨", column, ignore.case = TRUE))
}

# Find the indices of the columns containing the specified keywords
matching_indices <- which(apply(combined_data, 2, contains_keywords))

# Move the columns containing the specified keywords to the left
reordered_data <- combined_data %>%
    select(matching_indices, everything())

# Check the reordered data
head(reordered_data)

reordered_data <- combined_data %>%
    select(matches("먹는물|정제수|마그네슘|칼슘|칼륨"), everything())

# Check the reordered data
head(reordered_data)




# 필요한 패키지를 설치하고 로드
if (!require("dplyr")) install.packages("dplyr")
if (!require("stringr")) install.packages("stringr")

library(dplyr)
library(stringr)

# 데이터프레임 생성 (data는 위에서 주어진 데이터프레임)
data <- data.frame(
    # 데이터 입력
)

# 정규 표현식을 사용하여 키워드를 포함하는 행을 필터링
filtered_data <- combined_data %>%
    filter(apply(combined_data, 1, function(row) any(str_detect(row, "먹는물|정제수|마그네슘|칼슘|칼륨"))))

# 필터링된 데이터 출력
print(filtered_data)
