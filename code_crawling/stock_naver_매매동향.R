data = list()
url = paste0('https://finance.naver.com/item/frgn.nhn?code=005930')
down_table = GET(url)

#페이지 읽기
navi.final = read_html(down_table, encoding = 'EUC-KR') %>% 
  html_nodes(., '.pgRR') %>%  
  html_nodes(., 'a') %>%  
  html_attr(., 'href')

library(httr)
library(rvest)
