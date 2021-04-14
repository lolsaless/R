#명령프롬프트 실행
#java -Dwebdriver.gecko.driver="geckodriver.exe" -jar selenium-server-standalone-4.0.0-alpha-1.jar -port 4445

#라이브러리
library(RSelenium)
library(seleniumPipes)
library(rvest)
library(httr)

#크롬연결
remDr = remoteDriver(
  remoteServerAddr="localhost",
  port=4445L,
  browserName="chrome")

#크롬브라우저 오픈
remDr$open()

#페이지 수 확인
remDr$navigate('https://finance.naver.com/item/frgn.nhn?code=043650')
body <- remDr$getPageSource()[[1]]
body <- body %>% read_html(encoding = 'EUC-KR')
page <- body %>% 
  html_nodes(., '.pgRR') %>% 
  html_nodes(., 'a') %>% 
  html_attr(., 'href')

page <- strsplit(page, '=') %>% unlist(.) %>% 
  .[3] %>% as.numeric(.)



data <- list()
Sys.setlocale('LC_ALL', 'English')

for (i in 1:2) {
  print(i)
  url <- paste0('https://finance.naver.com/item/frgn.nhn?code=043650&page=',i)
  remDr$navigate(url)
  table = remDr$getPageSource()[[1]]
  
  table = remDr$getPageSource()[[1]] %>% read_html() %>% 
    html_table(fill = TRUE)
  
  data[i] <- table[3]
  Sys.sleep(5)
}
Sys.setlocale('LC_ALL', 'Korean')

data_df <- do.call(rbind, data)

data_df$날짜 <- ifelse(data_df$날짜 == "", NA, data_df$날짜)

library(tidyverse)
