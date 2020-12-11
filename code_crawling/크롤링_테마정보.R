library(rvest)
library(httr)

url = GET('https://finance.naver.com/sise/theme.nhn?&page=1')

down_url <- read_html(url, encoding = 'EUC-KR') %>%
  html_nodes(., '.col_type1') %>%
  html_nodes(., 'a') %>%
  html_attr(., 'href')

print(down_url)


text_data <- read_html(url, encoding = 'EUC-KR') %>%
  html_nodes(., '.col_type1') %>%
  html_nodes(., 'a') %>%
  html_text()



url_list <- list()
text_list <- list()

for (i in 1:6) {
  url <- GET(paste0('https://finance.naver.com/sise/theme.nhn?&page=',i))
  
  url_data <- read_html(url, encoding = 'EUC-KR') %>%
    html_nodes(., '.col_type1') %>%
    html_nodes(., 'a') %>%
    html_attr(., 'href')
  
  text_data <- read_html(url, encoding = 'EUC-KR') %>%
    html_nodes(., '.col_type1') %>%
    html_nodes(., 'a') %>%
    html_text()
  
  
  url_list[[i]] <- url_data
  text_list[[i]] <- text_data
  
  Sys.sleep(1)
}