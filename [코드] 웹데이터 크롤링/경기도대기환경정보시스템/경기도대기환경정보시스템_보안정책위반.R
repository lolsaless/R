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
locCd_path <- "C:/data/locCd.xlsx"

locCd <- readxl::read_excel(locCd_path)

data_air <- POST(url_air,
                 body = list(op = 'getByLoc',
                             fromDt = '2023-04-20',
                             toDt = '2023-04-20',
                             locCd = 131611,
                             typeCd = '1'),
                 add_headers(referer = ref_air))


data_air
