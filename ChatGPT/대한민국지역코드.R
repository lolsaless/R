# 대한민국 행정구역 정보 불러오기
library(dplyr)
library(readxl)

admi_code <- read_excel("https://www.code.go.kr/attachment/101/df011/100041.xlsx", col_names = TRUE)

# 행정표준코드에 해당하는 시, 군, 구, 동의 이름을 출력하는 함수
get_admi_name <- function(admi_code) {
  # 행정표준코드의 길이가 5인지 확인
  if (nchar(admi_code) != 5) {
    stop("Invalid admin code")
  }
  
  # 시, 군, 구, 동에 해당하는 코드 추출
  si_code <- substr(admi_code, 1, 2)
  gu_code <- substr(admi_code, 3, 4)
  dong_code <- substr(admi_code, 5, 6)
  
  # 시, 군, 구, 동에 해당하는 이름 추출
  si_name <- admi_code %>% 
    filter(CODE_SE = "0") %>% 
    filter(substr(ADM_CODE, 1, 2) == si_code) %>% 
    pull(ADM_NM)
  
  gu_name <- admi_code %>% 
    filter(CODE_SE = "1") %>% 
    filter(substr(ADM_CODE, 1, 4) == paste0(si_code, gu_code)) %>% 
    pull(ADM_NM)
  
  dong_name <- admi_code %>% 
    filter(CODE_SE = "2") %>% 
    filter(substr(ADM_CODE, 1, 6) == paste0(si_code, gu_code, dong_code)) %>% 
    pull(ADM_NM)
  
  # 시, 군, 구, 동에 해당하는 이름을 반환
  return(paste(si_name, gu_name, dong_name, sep = " "))
}
