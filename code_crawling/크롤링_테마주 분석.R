library(httr)
library(rvest)

url <- GET('https://finance.naver.com/sise/theme.nhn?&page=1')

page_number <- read_html(url, encoding = 'EUC-KR') %>%
  html_nodes(., '.pgRR') %>%
  html_nodes(., 'a') %>%
  html_attr(., 'href')

page_number <- page_number %>%
  strsplit(., '=') %>%
  unlist() %>%
  .[2] %>%
  as.numeric()

print(page_number)

ticker_list <- list()
theme_list <- list()

for (i in 1:page_number) {
  url <- paste0('https://finance.naver.com/sise/theme.nhn?&page=',i)
  url_data <- read_html(url, encoding = 'EUC-KR')
  
  url_ticker <- url_data %>%
    html_nodes(., '.col_type1') %>%
    html_nodes(., 'a') %>%
    html_attr(., 'href')
  
  url_theme <- url_data %>%
    html_nodes(., '.col_type1') %>%
    html_nodes(., 'a') %>%
    html_text()
  
  ticker_list[[i]] <- url_ticker
  theme_list[[i]] <- url_theme

  Sys.sleep(1)  
}

a <- unlist(theme_list)
a
b <- unlist(ticker_list)
b
c <- c(a, b)
print(c)

c <- data.frame(a,b)
