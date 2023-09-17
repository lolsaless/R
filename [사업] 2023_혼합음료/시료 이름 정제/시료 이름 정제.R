library(readxl)
library(dplyr)
library(stringr)
library(combinat)

# 파일 로드
file_path <- "시료명.xlsx"  # 실제 파일 경로로 수정해주세요.
sample_names_df <- read_excel(file_path)

# 알파벳 리스트 생성 및 조합
alphabets <- LETTERS
combinations <- combn(alphabets, 2, FUN = function(x) paste0(x, collapse = ""))

# 채취장소별 고유한 새로운 시료명 생성
unique_places <- sample_names_df %>% distinct(채취장소, .keep_all = TRUE)
unique_names <- character(nrow(unique_places))
for (i in 1:nrow(unique_places)) {
    if (unique_places$구분[i] == "혼합음료") {
        unique_names[i] <- paste0("m-", combinations[i])
    } else {
        unique_names[i] <- paste0("d-", combinations[i])
    }
}
unique_places$새로운시료명 <- unique_names

# 원래의 데이터프레임에 새로운 시료명 매핑
sample_names_df <- sample_names_df %>%
    left_join(unique_places %>% select(채취장소, 새로운시료명), by = "채취장소")

# 결과 저장
write.xlsx(sample_names_df, "revised_시료명_v3.xlsx", row.names = FALSE)