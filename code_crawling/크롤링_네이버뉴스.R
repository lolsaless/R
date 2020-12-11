library(rvest)
library(httr)
library(stringr)

#네이버 주가속보 크롤링
url <- 'https://finance.naver.com/news/mainnews.nhn'

data <- GET(url) %>%
  read_html(encoding = 'EUC-KR') %>%
  html_nodes('dl') %>%
  html_nodes('.articleSubject') %>%
  html_nodes('a') %>%
  html_text()

print(data)

#네이버 뉴스속보 크롤링

url1 <- 'https://news.naver.com/main/list.nhn?mode=LSD&mid=sec&sid1=001'
data1 <- GET(url1) %>%
  read_html(encoding = 'EUC-KR') %>%
  html_nodes('dl') %>%
  html_nodes('a') %>%
  html_text() %>%
  unique() %>%
  str_replace_all(., '\r\n\t\t\t\t\t\t\t\t', '')

print(data1)


#네이버 주요뉴스 크롤링

url2 <- 'https://finance.naver.com/news/mainnews.nhn'
data2 <- GET(url2) %>%
  read_html(encoding = 'EUC-KR') %>%
  html_nodes('dl') %>%
  html_nodes('.articleSubject') %>%
  html_nodes('a') %>%
  html_text()

print(data2)



for(i in 0:9) {
  print(i)
}


data <- 2

for(i in 0:9) {
  if( i != 0) {
    print(i*data)
  }
}
fuc <- function(x) {
        4 + i
}
data=1
i=2

fuc(a)
data + i

fuc()


for(i in 1:9) {
  for(ii in 2:9) {
    print(i*ii)
  }
}

for (i in 1:100) {
  if (2==2) {
    print(i^2)
  }
}

data <- list()

data <- c(1,2,3)
data
list(data)



library(httr)
library(rvest)


url <- 'https://news.naver.com/main/list.nhn?mode=LS2D&mid=shm&sid1=101&sid2=259'

data <- GET(url) %>%
  read_html(encoding = 'EUC-KR') %>%
  html_nodes('dl') %>%
  html_nodes('a') %>%
  html_text()
print(data)


url <- 'https://news.daum.net/ranking/popular/'
GET(url)

data <- GET(url) %>%
  read_html(.) %>%
  html_nodes('.list_news2') %>%
  html_nodes('div') %>%
  html_nodes('a') %>%
  html_text()
print(head(data))
print(data)
