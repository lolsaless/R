library(rvest)
library(httr)
library(dplyr)
library(tidyverse)
data = list()

# i = 0 은 코스피, i = 1 은 코스닥 종목
for (i in 0:1) {
    
    ticker = list()
    url =
        paste0('https://finance.naver.com/sise/',
               'sise_market_sum.nhn?sosok=',i,'&page=1')
    
    down_table = GET(url)
    
    # 최종 페이지 번호 찾아주기
    navi.final = read_html(down_table, encoding = "EUC-KR") %>%
        html_nodes(., ".pgRR") %>%
        html_nodes(., "a") %>%
        html_attr(.,"href") %>%
        strsplit(., "=") %>%
        unlist() %>%
        tail(., 1) %>%
        as.numeric()
    
    # 첫번째 부터 마지막 페이지까지 for loop를 이용하여 테이블 추출하기
    for (j in 1:navi.final) {
        
        # 각 페이지에 해당하는 url 생성
        url = paste0(
            'https://finance.naver.com/sise/',
            'sise_market_sum.nhn?sosok=',i,"&page=",j)
        down_table = GET(url)
        
        Sys.setlocale("LC_ALL", "English")
        # 한글 오류 방지를 위해 영어로 로케일 언어 변경
        
        table = read_html(down_table, encoding = "EUC-KR") %>%
            html_table(fill = TRUE)
        table = table[[2]] # 원하는 테이블 추출
        
        Sys.setlocale("LC_ALL", "Korean")
        # 한글을 읽기위해 로케일 언어 재변경
        
        table[, ncol(table)] = NULL # 토론식 부분 삭제
        table = na.omit(table) # 빈 행 삭제
        ticker[[j]] = table
        
        Sys.sleep(0.5) # 페이지 당 0.5초의 슬립 적용
    }
    
    # do.call을 통해 리스트를 데이터 프레임으로 묶기
    ticker = do.call(rbind, ticker)
    data[[i + 1]] = ticker
}

# 코스피와 코스닥 테이블 묶기
data = do.call(rbind, data)
rownames(data) <- NULL

data <- data[,2:ncol(data)]
str(data)
a <- data
a$PER <- as.numeric(a$PER)
a$ROE <- as.numeric(a$ROE)

a$현재가 <- parse_number(a$현재가)
stock_data <- data.frame(price = a$현재가, PER = a$PER, ROE = a$ROE)

stock <- data.frame(name = a$종목명, price = a$현재가, listed_stock = a$상장주식수, PER = a$PER, ROE = a$ROE)
stock$listed_stock <- parse_number(stock$listed_stock)

stock <- stock %>% mutate(PBR = ROE/100*PER)
stock <- na.omit(stock)

rownames(stock) <- NULL

ROE15 <- stock %>% filter(ROE >= 15 & price <= 50000 & PBR <= 2 & listed_stock <= 50000)
head(ROE15)
