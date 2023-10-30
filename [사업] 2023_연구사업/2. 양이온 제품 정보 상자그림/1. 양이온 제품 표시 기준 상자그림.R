library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggrepel)

load_data <- function(file_path) {
    read_excel(file_path)
}

process_data <- function(data) {
    data <- data[!duplicated(data$new_name), ]
    
    data_m <- data %>% filter(Separate_1 == "혼합음료")
    data_d <- data %>% filter(Separate_1 == "먹는샘물 제품수")
    
    list(data_m = data_m, data_d = data_d)
}

pivot_data <- function(data) {
    data %>% 
        pivot_longer(
            cols = c(Ca, K, Na, Mg, F), 
            names_to = "Element", 
            values_to = "Value"
        )
}

find_outliers <- function(data_long) {
    outliers <- data_long %>%
        group_by(Element) %>%
        summarise(q1 = quantile(Value, 0.25, na.rm = TRUE),
                  q3 = quantile(Value, 0.75, na.rm = TRUE)) %>%
        right_join(data_long, by = "Element") %>%
        mutate(outlier = Value < q1 - 1.5 * (q3 - q1) | Value > q3 + 1.5 * (q3 - q1),
               outlier = ifelse(is.na(Value), FALSE, outlier)) %>%
        filter(outlier)
    
    merged_data <- left_join(data_long, outliers %>% select(Element, Value, new_name, outlier), 
                             by = c("Element", "Value", "new_name"))
    
    merged_data$label <- ifelse(merged_data$outlier == TRUE, merged_data$new_name, NA)
    merged_data %>% select(-outlier)
}

plot_boxplot <- function(data, data_name) {
    ggplot(data, aes(Element, Value)) +
        geom_boxplot() + 
        geom_text_repel(
            aes(label = label),
            color = "black",
            size = 9/.pt,
            point.padding = 0.1, 
            box.padding = 0.6,
            min.segment.length = 0,
            max.overlaps = 1000,
            seed = 7654
        ) +
        ggtitle(data_name)
}


plot_all_data <- function(file_min, file_max) {
    data_min <- load_data(file_min)
    data_max <- load_data(file_max)
    
    processed_data_min <- process_data(data_min)
    processed_data_max <- process_data(data_max)
    
    datasets <- list(data_min_m_long = pivot_data(processed_data_min$data_m),
                     data_min_d_long = pivot_data(processed_data_min$data_d),
                     data_max_m_long = pivot_data(processed_data_max$data_m),
                     data_max_d_long = pivot_data(processed_data_max$data_d))
    
    for (name in names(datasets)) {
        print(name)
        data <- find_outliers(datasets[[name]])
        print(plot_boxplot(data, name))
    }
}

# 최종 함수 호출
plot_all_data("cation_min.xlsx", "cation_max.xlsx")
