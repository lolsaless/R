library(quantmod)
install.packages("quantmod")

getSymbols('AAPL')
head(AAPL)



install.packages("rvest")
library(rvest)
library(httr)

url <- 'https://finance.naver.com/news/news_list.nhn?mode=LSS2D&section_id=101&section_id2=258'

data <- GET(url)

print(data)

data_title <- data%>%
  read_html(encoding = 'EUC-KR')%>%
  html_nodes('dl') %>%
  html_nodes('.articleSubject')%>%
  html_nodes('a')%>%
  html_attr('title')
print(data_title)

install.packages("rmarkdown")
install.packages("knitr")
