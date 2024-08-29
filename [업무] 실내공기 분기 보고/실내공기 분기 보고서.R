library(tidyverse)

# Step 1: Load data
data_df <- read.csv("data.csv")
result_df <- read.csv("result.csv")

# Step 2-10: Combine and manipulate data using dplyr
data_final <- data_df %>%
    inner_join(result_df, by = "접수번호") %>%
    filter(str_detect(검체유형_x, "실내공기질")) %>%
    mutate(시설군 = str_split(검체유형_x, "/") %>% sapply("[", 3)) %>%
    select(
        시군명 = 의뢰기관,
        시설군,
        세부시설군 = 배출시설,
        시설명,
        주소 = 채취장소_x,
        `미세먼지(PM10)` = PM10,
        `초미세먼지(PM2.5)` = PM2.5,
        이산화탄소 = CO2,
        폼알데하이드,
        `총부유세균` = 부유세균,
        라돈,
        `라돈(밀폐)`,
        벤젠,
        톨루엔,
        에틸벤젠,
        자일렌,
        스틸렌,
        부적합항목,
        확인일,
        접수번호,
        접수번호_10자리 = substr(접수번호, 1, 10)
    ) %>%
    group_by(시설명, 접수번호_10자리) %>%
    mutate(
        채취지점 = paste(unique(시료명_x), collapse = ", ")
    ) %>%
    ungroup() %>%
    select(-시료명_x) %>%
    group_by(시설명, 접수번호_10자리) %>%
    summarize(
        across(c(`미세먼지(PM10)`, `초미세먼지(PM2.5)`, 이산화탄소, 폼알데하이드, `총부유세균`, 라돈), mean)
    ) %>%
    ungroup() %>%
    left_join(
        data_df %>%
            select(-c(시료명_x, PM10, PM2.5, CO2, 폼알데하이드, 부유세균, 라돈)) %>%
            distinct(시설명, 접수번호_10자리, .keep_all = TRUE),
        by = c("시설명", "접수번호_10자리")
    ) %>%
    arrange(
        시군명, 시설군, 세부시설군, 시설명, 주소, 채취지점,
        `미세먼지(PM10)`, `초미세먼지(PM2.5)`, 이산화탄소, 폼알데하이드, `총부유세균`, 라돈
    )

# Step 11: Save the final report
write.csv(data_final, "report_data.csv", row.names = FALSE)