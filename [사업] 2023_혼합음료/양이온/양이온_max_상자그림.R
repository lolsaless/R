library(readxl)
library(tidyverse)
library(writexl)
library(ggrepel)
data <- read_xlsx("20230917_merged_data_with_separate.xlsx")

# Remove duplicates based on 'name' and 'element' columns
deduplicated_data <- data %>%
    distinct(name, element, .keep_all = TRUE)

# Save the deduplicated data to a new Excel file
write_xlsx(deduplicated_data, "deduplicated_merged_data.xlsx")

# 먹는샘물, 혼합음료 구분하기
data <- deduplicated_data %>% filter(separate == "먹는샘물")

outliers <- data %>%
    group_by(element) %>%
    summarise(q1 = quantile(concentration, 0.25, na.rm = TRUE),
              q3 = quantile(concentration, 0.75, na.rm = TRUE)) %>%
    right_join(data, by = "element") %>%
    mutate(outlier = concentration < q1 - 1.5 * (q3 - q1) | concentration > q3 + 1.5 * (q3 - q1),
           outlier = ifelse(is.na(concentration), FALSE, outlier)) %>%
    filter(outlier)

# data_long와 outliers를 ['element', 'concentration', '제품명']을 기준으로 합칩니다.
merged_data <- left_join(data, outliers %>% select(element, concentration, new_name, outlier), 
                         by = c("element", "concentration", "new_name"))

# 'outlier' 열이 TRUE인 경우에만 '제품명' 값을 'label' 열에 할당합니다.
merged_data$label <- ifelse(merged_data$outlier == TRUE, merged_data$new_name, NA)

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
