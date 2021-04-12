Sys.setenv(JAVA_HOME='C:/Program Files/Java/jre1.8.0_281')


#java -Dwebdriver.gecko.driver="geckodriver.exe" -jar selenium-server-standalone-4.0.0-alpha-1.jar -port 4445


install.packages('Rselenium')
library(RSelenium)
library(seleniumPipes)
library(rvest)
library(httr)

remDr = remoteDriver(
  remoteServerAddr="localhost",
  port=4445L,
  browserName="chrome")

remDr$open()
remDr$navigate('https://finance.naver.com/item/frgn.nhn?code=000890')



page_parse = remDr$getPageSource()[[1]]
page_html = page_parse %>% read_html()

Sys.setlocale('LC_ALL', 'English')
table = page_html %>% html_table(fill = TRUE)
Sys.setlocale('LC_ALL', 'Korean')

df <- table[3]
df
aaaaa