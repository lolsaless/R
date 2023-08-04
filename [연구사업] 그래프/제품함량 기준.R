library(readxl)
library(ggplot2)
library(tidyr)
library(dplyr)

# data.xlsx 파일 로드
# data는 제품 함량(ca, mg, na, k, f)
data <- read_excel("data.xlsx")

# 데이터를 '긴 형식'으로 변환
data_long <- data %>% 
  pivot_longer(cols = c(Ca, K, Na, Mg, F), names_to = "Element", values_to = "Value") %>% 
  mutate(ValAdj = if_else(구분 == "최소", -Value, Value))  # 최소값을 음수로 변환

# 그래프 생성
ggplot(data_long, aes(x=Element, y=ValAdj, fill=구분)) +
  geom_bar(stat="identity", position="identity") +
  coord_flip() +  # x축과 y축을 바꾸어 수평 막대 그래프로 만듭니다.
  labs(x="Element", y="Value", fill="구분") +
  scale_y_continuous(labels = abs, breaks = seq(-30, 30, by = 10)) +  # y축 레이블을 절댓값으로 표시
  theme_minimal() +
  facet_wrap(~제품명, scales = "free_y")  # 제품별로 그래프를 나눕니다.
