# 라이브러리 불러오기
library(ggplot2)
library(readxl)
library(RColorBrewer)
library(dplyr)
library(tidyr)

# 데이터 불러오기
data <- read_excel("o,n_phenol.xlsx")

# 각 그룹의 평균 계산
grouped_mean <- aggregate(. ~ group, data, mean)

# 0이 아닌 NP와 OP의 비율 계산
np_density <- aggregate(NP ~ group, data, function(x) mean(x > 0))$NP
op_density <- aggregate(OP ~ group, data, function(x) mean(x > 0))$OP

# 그룹별 평균 데이터와 검출 빈도 데이터를 합침
grouped_mean$np_density <- np_density
grouped_mean$op_density <- op_density

# 데이터를 긴 형식으로 변경
data_long <- grouped_mean %>%
    pivot_longer(cols = c(NP, OP), names_to = "type", values_to = "value") %>%
    pivot_longer(cols = c(np_density, op_density), names_to = "density_type", values_to = "density")

# 그래프 생성
ggplot(data = data_long, aes(x = group, y = value, fill = density)) +
    geom_bar(aes(group = interaction(group, type), fill = ifelse(type == "NP", density, NA)), 
             stat = "identity", position = "dodge", width = 0.35) +
    geom_bar(aes(group = interaction(group, type), fill = ifelse(type == "OP", density, NA)), 
             stat = "identity", position = "dodge", width = 0.35) +
    scale_fill_gradient(low = "lightgray", high = "blue") +
    labs(y = "Values", title = "Mean values by group with detection density") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
