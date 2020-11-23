library(httr)
library(rvest)



i <- 0
ticker <- list()

url <- paste0('https://finance.naver.com/sise/','sise_market_sum.nhn?sosok=',i,'&page=1')
down_table <- GET(url)

navi.final <- read_html(down_table, encoding = 'EUC-KR') %>%
  html_nodes(., '.pgRR') %>%
  html_nodes(., 'a') %>%
  html_attr(., 'href')

print(navi.final)

navi.final <- navi.final %>%
  strsplit(., '=') %>%
  unlist() %>%
  tail(., 1) %>%
  as.numeric()
print(navi.final)

