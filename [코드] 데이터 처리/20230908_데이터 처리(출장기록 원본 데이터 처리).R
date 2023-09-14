library(tidyverse)
library(writexl)

raw_data <- readxl::read_xls("raw_data.xls")

# 1번 열에서 숫자가 아닌 데이터를 갖는 행을 필터링하여 삭제
data_1 <- raw_data[!is.na(as.numeric(as.character(raw_data[[1]]))), ]

# 열에 아무런 데이터가 없다면 삭제
data_2 <- data_1[, colSums(is.na(data_1)) != nrow(data_1)]

# 출장기간 열을 ~ 기준으로 분리
data_3 <- data_2 %>% separate(출장기간, into = c("출발일시", "도착일시"), sep = " ~ ")

# 출발일시, 도착일시 열을 날짜와 시간으로 분리
data_4 <- data_3 %>% 
    separate(출발일시, into = c("출발일", "출발시간"), sep = " ", extra = "merge") %>%
    separate(도착일시, into = c("도착일", "도착시간"), sep = " ", extra = "merge")

# 이름코드 열을 괄호 기준으로 분리
df <- data_4 %>% separate(성명, into = c("이름", "코드"), sep = "\\(", extra = "merge")

# 코드 열에서 괄호 제거
df$코드 <- gsub(")", "", df$코드)

write_xlsx(df, "완성본.xlsx")
