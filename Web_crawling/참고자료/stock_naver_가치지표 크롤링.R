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
remDr$navigate('https://finance.naver.com/sise/sise_market_sum.nhn')

data = list()
# i = 0 은 코스피, i = 1 은 코스닥 종목
for (i in 0:1) {
  
  ticker = list()
  
  url = paste0('https://finance.naver.com/sise/',
               'sise_market_sum.nhn?sosok=',i,
               '&page=1')
  
  remDr$navigate(url)
  
  down_table <- remDr$getPageSource()[[1]]
  
  navi.final = read_html(down_table, encoding = "EUC-KR") %>%
    html_nodes(., ".pgRR") %>%
    html_nodes(., "a") %>%
    html_attr(.,"href") %>%
    strsplit(., "=") %>%
    unlist() %>%
    tail(., 1) %>%
    as.numeric()
  
  for (j in 1:navi.final) {
    
    url = paste0('https://finance.naver.com/sise/',
                 'sise_market_sum.nhn?sosok=',i,
                 "&page=",j)
    
    remDr$navigate(url)
    
    down_table <- remDr$getPageSource()[[1]]
    
    Sys.setlocale("LC_ALL", "English")
    
    table = read_html(down_table, encoding = "EUC-KR") %>%
      html_table(fill = TRUE)
    table = table[[2]]
    
    Sys.setlocale("LC_ALL", "Korean")
    
    table[, ncol(table)] = NULL
    table = na.omit(table)
    ticker[[j]] = table
    
    if (i == 0) {
      print(paste0('코스피-',j,'page'))
    } else {
      print(paste0('코스닥-',j,'page'))
    }
    Sys.sleep(5)
  }
  
  ticker = do.call(rbind, ticker)
  data[[i + 1]] = ticker
}

data_table = do.call(rbind, data)
data_table <- data_table[,2:ncol(data_table)]

write.csv(data_table, 'data.csv')
