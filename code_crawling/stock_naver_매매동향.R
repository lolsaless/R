#java -Dwebdriver.gecko.driver="geckodriver.exe" -jar selenium-server-standalone-4.0.0-alpha-1.jar -port 4445
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


body <- remDr$getPageSource()[[1]]
body <- body %>% read_html(encoding = 'EUC-KR')

page <- body %>% 
  html_nodes(., '.pgRR') %>% 
  html_nodes(., 'a') %>% 
  html_attr(., 'href')
page <- strsplit(page, '=')
page <- unlist(page)
page
a <- page[3]
a
as.numeric(a)


a <- list()
Sys.setlocale('LC_ALL', 'English')

for (i in 1:2) {
  print(i)
  url <- paste0('https://finance.naver.com/item/frgn.nhn?code=043650&page=',i)
  remDr$navigate(url)
  page = remDr$getPageSource()[[1]]
  
  page = remDr$getPageSource()[[1]] %>% read_html() %>% 
    html_table(fill = TRUE)
  
  a[i] <- page[3]
  Sys.sleep(5)
}
Sys.setlocale('LC_ALL', 'Korean')

b <- do.call(rbind, a)

c <- na.omit(b)
c
library(dplyr)
b[!(is.na(b$종가)),]
row(b, NULL)

b$날짜 <- ifelse(b$날짜 == "", NA, b$날짜)
b <- na.omit(b)
