for (i in number) {
  print(i^2)
}

for(i in number) {
  tryCatch({
    print(i^2)
  }, error = function(e){
    print(paste('Error', i))
  })
}

library(quantmod)
getSymbols('SPY')
tail(SPY)
head(SPY)

chart_Series(Ad(SPY))

SPY %>% Ad() %>% chart_Series()

apple_data <- getSymbols('AAPL',
                         from = '2000-01-01', to = '2018-12-31',
                         auto.assign = FALSE)

ticker <- c('FB', 'NVDA')
getSymbols(ticker
           )

getSymbols('DGS10', src='FRED')

library(rvest)
library(httr)
url <- 'https://finance.naver.com/news/news_list.nhn?mode=LSS2D&section_id=101&section_id2=258'
data <- GET(url)
print(data)

data_title <- data %>%
  read_html(encoding = 'EUC-KR') %>%
  html_nodes('dl') %>%
  html_nodes('.articleSubject') %>%
  html_nodes('a') %>%
  html_attr('title')

head(data_title)

print(data_title)

Sys.setlocale('LC_ALL', 'English')

url <- 'https://kind.krx.co.kr/disclosure/todaydisclosure.do'
data <- POST(url, body =
               list(
                 method = 'searchTodayDisclosureSub',
                 currentPageSize = '15',
                 pageIndex = '1',
                 orderMode = '0',
                 orderStat = 'D',
                 marketType = '2',
                 forward = 'todaydisclosure_sub',
                   chose = 'S',
                 todayFlag = 'N',
                   selDate = '2020-10-23'
               ))

print(data)
data <- read_html(data) %>%
  html_table(fill = TRUE) %>% .[[1]]

Sys.setlocale('LC_ALL', 'Korean')
print(data)




