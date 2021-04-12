Sys.setenv(JAVA_HOME='C:/Program Files/Java/jre1.8.0_281')


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
a <- remDr$findElement(using = 'xpath',
                  value = '//*[@id="content"]/div[2]/table[2]/tbody/tr/td[12]/a')


html_text(a)
