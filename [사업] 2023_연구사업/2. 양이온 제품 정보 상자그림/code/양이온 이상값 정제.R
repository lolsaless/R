library(readxl)
library(tidyverse)
library(writexl)
library(ggrepel)
data <- read_xlsx("20230917_deduplicated_data.xlsx")

data_long <- data %>%
    pivot_longer(cols = -제품명, names_to = "element", values_to = "concentration")

outliers <- data_long %>%
    group_by(element) %>%
    summarise(q1 = quantile(concentration, 0.25, na.rm = TRUE),
              q3 = quantile(concentration, 0.75, na.rm = TRUE)) %>%
    right_join(data_long, by = "element") %>%
    mutate(outlier = concentration < q1 - 1.5 * (q3 - q1) | concentration > q3 + 1.5 * (q3 - q1),
           outlier = ifelse(is.na(concentration), FALSE, outlier)) %>%
    filter(outlier)

# data_long와 outliers를 ['element', 'concentration', '제품명']을 기준으로 합칩니다.
merged_data <- left_join(data_long, outliers %>% select(element, concentration, 제품명, outlier), 
                         by = c("element", "concentration", "제품명"))

# 'outlier' 열이 TRUE인 경우에만 '제품명' 값을 'label' 열에 할당합니다.
merged_data$label <- ifelse(merged_data$outlier == TRUE, merged_data$제품명, NA)

# 'outlier' 열을 삭제합니다.
merged_data <- merged_data %>% select(-outlier)

# 결과를 확인합니다.
head(merged_data)

ggplot(merged_data, aes(element, concentration)) +
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
