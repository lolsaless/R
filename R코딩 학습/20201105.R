library(httr)
library(rvest)
library(readr)

<<<<<<< HEAD
=======
swhoememe
>>>>>>> 1972984bd6ff409d7b0ff267037d38c66208177d
gen_otp_url =
  'http://marketdata.krx.co.kr/contents/COM/GenerateOTP.jspx'
gen_otp_data = list(
  name = 'fileDown',
  filetype = 'csv',
  url = 'MKD/03/0303/03030103/mkd03030103',
  tp_cd = 'ALL',
  date = '20201029',
  lang = 'ko',
  pagePath = '/contents/MKD/03/0303/03030103/MKD03030103.jsp')
otp = POST(gen_otp_url, query = gen_otp_data) %>%
  read_html() %>%
  html_text()
otp

down_url = 'http://file.krx.co.kr/download.jspx'
down_sector = POST(down_url, query = list(code = otp),
                   add_headers(referer = gen_otp_url)) %>%
  read_html() %>%
  html_text() %>%
  read_csv()
print(down_sector)


library(httr)
library(rvest)
library(stringr)

url = 'https://finance.naver.com/sise/sise_deposit.nhn'

biz_day = GET(url) %>%
  read_html(encoding = 'EUC-KR') %>%
  html_nodes(xpath =
               '//*[@id="type_1"]/div/ul[2]/li/span') %>%
  html_text() %>%
  str_match(('[0-9]+.[0-9]+.[0-9]+') ) %>%
  str_replace_all('\\.', '')

print(biz_day)


down_sector = read.csv('data/krx_sector.csv', row.names = 1,
                       stringsAsFactors = FALSE)
down_ind = read.csv('data/krx_ind.csv',  row.names = 1,
                    stringsAsFactors = FALSE)

KOR_ticker = merge(down_sector, down_ind,
                   by = intersect(names(down_sector),
                                  names(down_ind)),
                   all = FALSE
)

KOR_ticker = KOR_ticker[order(-KOR_ticker['시가총액.원.']), ]
print(head(KOR_ticker))


library(stringr)
library(stringr)

KOR_ticker[grepl('스팩', KOR_ticker[, '종목명']), '종목명']
KOR_ticker[str_sub(KOR_ticker[, '종목코드'], -1, -1) != 0, '종목명']

KOR_ticker[str_sub(KOR_ticker[, '종목코드'], -1, -1) !=0, '종목명']

KOR_ticker <- KOR_ticker[!grepl('스팩', KOR_ticker[, '종목명']),]
KOR_ticker <- KOR_ticker[str_sub(KOR_ticker[, '종목코드'], -1, -1) ==0,]

rownames(KOR_ticker) = NULL




#WICS 기준 섹터정보 크롤링


KOR_sector <- read.csv('data/KOR_sector.csv')



#재무제표 다운로드
library(httr)
library(rvest)

ifelse(dir.exists('data/KOR_fs'), FALSE,
       dir.create('data/KOR_fs'))

Sys.setlocale("LC_ALL", "English")

url = paste0('http://comp.fnguide.com/SVO2/ASP/SVD_Finance.asp?pGB=1&gicode=A005930')

data = GET(url,
           user_agent('Mozilla/5.0 (Windows NT 10.0; Win64; x64)
                      AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.77 Safari/537.36'))
data = data %>%
  read_html() %>%
  html_table()

Sys.setlocale("LC_ALL", "Korean")

lapply(data, function(x) {
  head(x,3)
})

head(data)

data_IS = data[[1]]
data_BS = data[[3]]
data_CF = data[[5]]

print(names(data_IS))

data_IS <- data_IS[,1:(ncol(data_IS)-2)]

#data_IS <- data_IS[1:(nrow(data_IS)-10),]


data_fs <-  rbind(data_IS, data_BS, data_CF)
data_fs[, 1] <-  gsub('계산에 참여한 계정 펼치기', '', data_fs[, 1])

data_fs <- data_fs[!duplicated(data_fs[,1]),]



rownames(data_fs) = NULL
rownames(data_fs) = data_fs[, 1]
data_fs[, 1] = NULL

data_fs = data_fs[, substr(colnames(data_fs), 6,7) == '12']

colnames(data_fs)
library(stringr)

data_fs <- sapply(data_fs, function(x) {
  str_replace_all(x, ',', '') %>% as.numeric()
}) %>% data.frame(., row.names = row.names(data_fs)) 


value_type <- c('지배주주순이익', '자본', '영업활동으로인한현금흐름', '매출액')

value_index <- data_fs[match(value_type, rownames(data_fs)), ncol(data_fs)]

ncol(data_fs)

data_fs[1,2]


print(value_index)

library(readr)

url = 'http://comp.fnguide.com/SVO2/ASP/SVD_main.asp?pGB=1&gicode=A005930'
data = GET(url,
           user_agent('Mozilla/5.0 (Windows NT 10.0; Win64; x64)
                      AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.77 Safari/537.36'))

price = read_html(data) %>%
  html_node(xpath = '//*[@id="svdMainChartTxt11"]') %>%
  html_text() %>%
  parse_number()

print(price)


share = read_html(data) %>%
  html_node(
    xpath =
      '//*[@id="svdMainGrid1"]/table/tbody/tr[7]/td[1]') %>%
  html_text()

print(share)

share <- share %>% strsplit('/') %>% unlist() %>% .[1] %>% parse_number()
print(share)
as.numeric(share)
is.numeric(share)


data_value <- price/(value_index/share*100000000)
names(data_value) <- c('PER', 'PBR', 'PCR', 'PSR')
data_value[data_value < 0] = NA
print(data_value)



KOR_ticker <- read.csv('KOR_ticker.csv', row.names = 1)
KOR_ticker$종목코드 <- str_pad(KOR_ticker$종목코드, 6, side = c('left'), pad = '0')


name <- KOR_ticker$'종목코드'[i]


nrow(KOR_ticker)
for(i in 1:nrow(KOR_ticker)) {
  name <- KOR_ticker$종목코드[i]
}
