Sys.setenv(JAVA_HOME='C:/Program Files/Java/jre1.8.0_281')

#java -Dwebdriver.gecko.driver="geckodriver.exe" -jar selenium-server-standalone-4.0.0-alpha-1.jar -port 4445
#java -Dwebdriver.gecko.driver="geckodriver.exe" -jar selenium-server-standalone-4.0.0-beta-2.jar -port 4445

install.packages('Rselenium')
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
remDr$navigate('https://finance.naver.com/item/frgn.nhn?code=043650')

#웹페이지 정보 읽기
Sys.setlocale('LC_ALL', 'English')
page_html = remDr$getPageSource()[[1]] %>% read_html()

Sys.setlocale('LC_ALL', 'English')
table = page_html %>% html_table(fill = TRUE)
Sys.setlocale('LC_ALL', 'Korean')

remDr$navigate('https://finance.naver.com/item/frgn.nhn?code=043650')

lists



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
for (i in 1:2) {
  print(i)
  url <- paste0('https://finance.naver.com/item/frgn.nhn?code=043650&page=',i)
  remDr$navigate(url)
  page_parse = remDr$getPageSource()[[1]]
  
  Sys.sleep(3)
}
