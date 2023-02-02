library(httr)
library(rvest)

url <- 'https://finance.naver.com/news/news_list.nhn?mode=LSS2D&section_id=101&section_id2=258'

data <- GET(url)
print(data)

data_title <- read_html(data, encoding = 'EUC-KR') %>%
              html_nodes('dl') %>%
              html_nodes('.articleSubject') %>%
              html_nodes('a') %>%
              html_attr('title')
print(data_title)


#데이터 다운로드
###수원시자원회수시설 데이터
Sys.setlocale('LC_ALL', 'English')
url <- 'http://www.rrfsuwon.co.kr/_Skin/24_1.php'

data <- POST(url, body = list(
  gubun = 'period',
  sYear = '2020',
  sMonth = '10',
  sDate = '2020-01-01',
  eDate = '2020-10-29'
))

data_suwon <- read_html(data) %>% html_table(fill = T) %>% .[[1]]

Sys.setlocale('LC_ALL', 'Korean')

data_suwon$일자 <- str_replace_all(data_suwon$일자, '\\.', '')
data_suwon <- data_suwon[-1,]
rownames(data_suwon) <- NULL
data_suwon <- data_suwon[-c(304:307),]

colnames(data_suwon) <- c('일자', '반입', '소각', '바닥재', '비산재')
data_suwon <- data_suwon[,-6]
print(head(data_suwon))

library(lubridate)
data_suwon[,1] <- ymd(data_suwon[,1])

library(timetk)
i <- data_suwon[,c(1,2)]
is.data.frame(i)

?data.frame

