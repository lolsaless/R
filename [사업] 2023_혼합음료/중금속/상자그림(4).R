# 필요한 패키지 설치
install.packages(c("readxl", "ggplot2", "tidyverse"))

# 패키지 로드
library(readxl)
library(ggplot2)
library(tidyverse)

# 엑셀 파일 불러오기
data <- read_excel("제품수 함량.xlsx")

# 데이터 정리: wide format에서 long format으로 변경
data_long <- data %>%
  pivot_longer(cols = c("Ca", "K", "Na", "Mg", "F"),
               names_to = "Element",
               values_to = "Value")

# 상자그림(box plot) 그리기
ggplot(data_long, aes(x = 제품명, y = Value, fill = 구분)) +
  geom_boxplot() +
  facet_wrap(~Element, scales = "free") +  # 각 원소에 대해 별도의 그림을 그림
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +  # x축 레이블을 45도 각도로 회전
  labs(x = "Product Name", y = "Value", fill = "Category")   # 축 레이블 변경

