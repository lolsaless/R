# 패키지 로드
if (!require(pacman)) {
    install.packages("pacman")
    library(pacman)
}

pacman::p_load(rvest, httr, jsonlite, readxl)

folder_path <- "C:/data/tms"  # 폴더 경로를 지정합니다.

if (!file.exists(folder_path)) {
    dir.create(folder_path)
} else {
    cat("폴더가 이미 존재합니다.\n")
}

setwd("C:/data/tms")

# 크롤링 url
url_air <- 'https://air.gg.go.kr/default/tms.do'
ref_air <- 'https://air.gg.go.kr/default/esData.do?mCode=A010010000'

# body에 들어갈 부분이며, 각 측정 지점의 고유 번호가 저장된 csv파일을 불러온다.
# 워킹 디렉토리 변경 대신에 파일의 절대 경로를 사용합니다.
locCd_path <- "C:/Github/R_coding/[코드] 웹데이터 크롤링/경기도대기환경정보시스템/locCd.xlsx"
locCd_path <- "D:/R_coding/[코드] 웹데이터 크롤링/경기도대기환경정보시스템/locCd.xlsx"

locCd <- readxl::read_excel(locCd_path)

# 시간단위 측정결과 연간 자료 다운로드 가능
for (year in 2020:2021) {
    from_year <- paste0(year,"-01-01")
    to_year <- paste0(year, "-12-31")
    count = 0
    
    for (i in 1:nrow(locCd)) {
        count = count + 1
        data_air <- httr::POST(url_air,
                               body = list(op = 'getByLoc',
                                           fromDt = from_year,
                                           toDt = to_year,
                                           locCd = as.numeric(locCd[i,1]),
                                           typeCd = '3'),
                               httr::user_agent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36'),
                               httr::add_headers(referer = ref_air))
        
        air_gg <- data_air %>% httr::content(as='text') %>% jsonlite::fromJSON() %>% do.call(rbind,.)
        file_name <- paste0(year, '_', locCd$지역[count], '_', locCd$지점[count], '.csv')
        write.csv(air_gg, file_name, row.names = FALSE)
        message(paste0(file_name, " 파일 크롤링 완료"))
        Sys.sleep(10.0)
    }
}
