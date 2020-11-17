library(httr)
library(rvest)
library(readr)

# 1. KRX Sector 크롤링
## 시장구분, 종목코드, 종목명, 산업분류, 현재가(설정날짜 기준), 현재가, 전일대비, 시가총액(원)

gen_otp_url =
  'http://marketdata.krx.co.kr/contents/COM/GenerateOTP.jspx'
gen_otp_data = list(
  name = 'fileDown',
  filetype = 'csv',
  url = 'MKD/03/0303/03030103/mkd03030103',
  tp_cd = 'ALL',
  date = '20201016',
  lang = 'ko',
  pagePath = '/contents/MKD/03/0303/03030103/MKD03030103.jsp')
otp = POST(gen_otp_url, query = gen_otp_data) %>%
  read_html() %>%
  html_text()

down_url = 'http://file.krx.co.kr/download.jspx'
down_sector = POST(down_url, query = list(code = otp),
                   add_headers(referer = gen_otp_url)) %>%
  read_html() %>%
  html_text() %>%
  read_csv()

ifelse(dir.exists('data'), FALSE, dir.create('data'))
write.csv(down_sector, 'data/krx_sector.csv')


# 2. 개별종목 지표 크롤링
## 일자, 종목코드, 종목명, 관리여부, 종가, EPS, PER, BPS, PBR, 주당배당금 및 기타 등등.
library(httr)
library(rvest)
library(readr)

gen_otp_url =
  'http://marketdata.krx.co.kr/contents/COM/GenerateOTP.jspx'
gen_otp_data = list(
  name = 'fileDown',
  filetype = 'csv',
  url = "MKD/13/1302/13020401/mkd13020401",
  market_gubun = 'ALL',
  gubun = '1',
  schdate = '20201016',
  pagePath = "/contents/MKD/13/1302/13020401/MKD13020401.jsp")

otp = POST(gen_otp_url, query = gen_otp_data) %>%
  read_html() %>%
  html_text()

down_url = 'http://file.krx.co.kr/download.jspx'
down_ind = POST(down_url, query = list(code = otp),
                add_headers(referer = gen_otp_url)) %>%
  read_html() %>%
  html_text() %>%
  read_csv()

write.csv(down_ind, 'data/krx_ind.csv')


# 3. 거래소 데이터 정리
## 우, 스팩 등 필요하지 않은 데이터 정리.
down_sector = read.csv('data/krx_sector.csv', row.names = 1, stringsAsFactors = FALSE)
down_ind =read.csv('data/krx_ind.csv', row.names = 1, stringsAsFactors = F)
intersect(names(down_sector), names(down_ind))
setdiff(down_sector[, '종목명'], down_ind[,'종목명'])

KOR_ticker = merge(down_sector, down_ind,
                   by = intersect(names(down_sector),
                                  names(down_ind)),
                   all = FALSE
)

KOR_ticker = KOR_ticker[order(-KOR_ticker['시가총액.원.']),]
library(stringr)
KOR_ticker[grepl('스팩', KOR_ticker[,'종목명']), '종목명']
KOR_ticker[str_sub(KOR_ticker[, '종목코드'], -1, -1) !=0, '종목명']

KOR_ticker = KOR_ticker[!grepl('스팩', KOR_ticker[,'종목명']), ]
KOR_ticker = KOR_ticker[str_sub(KOR_ticker[, '종목코드'], -1, -1) == 0, ]
rownames(KOR_ticker) = NULL
write.csv(KOR_ticker, 'data/KOR_ticker.csv')


# 4. 섹터분류
## 업종별 섹터로 나눠서 크롤링
library(jsonlite)

url = 'http://www.wiseindex.com/Index/GetIndexComponets?ceil_yn=0&dt=20190607&sec_cd=G10'
data = fromJSON(url)

lapply(data, head)

sector_code = c('G25', 'G35', 'G50', 'G40', 'G10',
                'G20', 'G55', 'G30', 'G15', 'G45')
data_sector = list()

for (i in sector_code) {
  
  url = paste0(
    'http://www.wiseindex.com/Index/GetIndexComponets',
    '?ceil_yn=0&dt=',20201016,'&sec_cd=',i)
  data = fromJSON(url)
  data = data$list
  
  data_sector[[i]] = data
  
  Sys.sleep(1)
}

data_sector = do.call(rbind, data_sector)

write.csv(data_sector, 'data/KOR_sector.csv')