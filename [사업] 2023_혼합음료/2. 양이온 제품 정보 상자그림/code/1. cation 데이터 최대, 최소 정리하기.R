library(tidyverse)
library(readxl)
library(writexl)
library(ggrepel)

data <- read_xlsx("20230917_sample_list(cation).xlsx")

data_min <- data %>% filter(minmax == "최소") %>% 
    select(Sample_number, raw_sample_number, Name, new_name, Separate_1, Ca, K, Na, Mg, F)

data_max <- data %>% filter(minmax == "최대") %>% 
    select(Sample_number, raw_sample_number, Name, new_name, Separate_1, Ca, K, Na, Mg, F)

write_xlsx(data_min, "cation_min.xlsx")
write_xlsx(data_max, "cation_max.xlsx")

# Remove duplicates based on the 'new_name' column
data_min <- data_min[!duplicated(data_min$new_name), ]
data_max <- data_max[!duplicated(data_max$new_name), ]

# 혼합음료, 먹는샘물 구분하기
data_min_m <- data_min %>% filter(Separate_1 == "혼합음료")
data_min_d <- data_min %>% filter(Separate_1 == "먹는샘물 제품수")

data_max_m <- data_max %>% filter(Separate_1 == "혼합음료")
data_max_d <- data_max %>% filter(Separate_1 == "먹는샘물 제품수")



# pivot_longer 함수를 사용하여 데이터를 변환합니다
data_min_m_long <- data_min_m %>% 
    pivot_longer(
        cols = c(Ca, K, Na, Mg, F), 
        names_to = "Element", 
        values_to = "Value"
    )

data_min_d_long <- data_min_d %>% 
    pivot_longer(
        cols = c(Ca, K, Na, Mg, F), 
        names_to = "Element", 
        values_to = "Value"
    )

data_max_m_long <- data_max_m %>% 
    pivot_longer(
        cols = c(Ca, K, Na, Mg, F), 
        names_to = "Element", 
        values_to = "Value"
    )

data_max_d_long <- data_max_d %>% 
    pivot_longer(
        cols = c(Ca, K, Na, Mg, F), 
        names_to = "Element", 
        values_to = "Value"
    )

# cation_min_d(drinking water)
outliers <- data_min_d_long %>%
    group_by(Element) %>%
    summarise(q1 = quantile(Value, 0.25, na.rm = TRUE),
              q3 = quantile(Value, 0.75, na.rm = TRUE)) %>%
    right_join(data_min_d_long, by = "Element") %>%
    mutate(outlier = Value < q1 - 1.5 * (q3 - q1) | Value > q3 + 1.5 * (q3 - q1),
           outlier = ifelse(is.na(Value), FALSE, outlier)) %>%
    filter(outlier)

# data_long와 outliers를 ['element', 'concentration', '제품명']을 기준으로 합칩니다.
merged_data <- left_join(data_min_d_long, outliers %>% select(Element, Value, new_name, outlier), 
                         by = c("Element", "Value", "new_name"))

# 'outlier' 열이 TRUE인 경우에만 '제품명' 값을 'label' 열에 할당합니다.
merged_data$label <- ifelse(merged_data$outlier == TRUE, merged_data$new_name, NA)

# 'outlier' 열을 삭제합니다.
merged_data <- merged_data %>% select(-outlier)

# 결과를 확인합니다.
head(merged_data)

ggplot(merged_data, aes(Element, Value)) +
    geom_boxplot() + 
    geom_text_repel(
        aes(label = label),
        color = "black",
        size = 9/.pt, # font size 9 pt
        point.padding = 0.1, 
        box.padding = 0.6,
        min.segment.length = 0,
        max.overlaps = 1000,
        seed = 7654 # For reproducibility reasons
    )
