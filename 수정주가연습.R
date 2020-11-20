#수정주가 크롤링
library(stringr)

KOR_ticker <- read.csv('data/KOR_ticker.csv', row.names = 1)
#row.names 함수를 이용해서, 행의 이름을 첫 번째 행으로 설정

KOR_ticker$종목코드 <- str_pad(KOR_ticker$종목코드, 6, side = c('left'), pad = '0')

library(xts)

i = 1
name <- KOR_ticker$종목코드[i]

price <- xts(NA, order.by = Sys.Date())
print(price)


library(httr)

url <- paste0('https://fchart.stock.naver.com/sise.nhn?symbol=',
  name,'&timeframe=day&count=500&requestType=0')
data <- GET(url)
data_html <- read_html(data, encoding='EUC-KR') %>%
  html_nodes('item') %>%
  html_attr('data')
?html_nodes

print(data_html)

library(readr)

price <- read_delim(data_html, delim = '|')
print(price)



