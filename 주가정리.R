library(stringr)
library(xts)
library(magrittr)

ticker <- read.csv('data/KOR_ticker.csv', row.names = 1)
ticker$종목코드 <- str_pad(ticker$종목코드, 6, side = c('left'), pad = '0')

price_list <- list()

for (i in 1:nrow(ticker)) {
  
  name <-  ticker[i, 1]
  price_list[[i]] <- read.csv(paste0('KOR_price/',name,'_price.csv'), row.names = 1) %>%
    as.xts()
}

price_list <- do.call(cbind, price_list) %>%na.locf()
colnames(price_list) <- ticker$종목코드

#do.call&cbind 함수 이해하기.

list <- list(col1 = list (1,2,3), col2 = list(3,4,5), col3 = list(6,7,8))
list

list1 <- do.call(cbind, list)
list1
