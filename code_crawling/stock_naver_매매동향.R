data = list()
url = paste0('https://finance.naver.com/item/frgn.nhn?code=005930')
down_table = GET(url)

#페이지 읽기
navi.final = read_html(down_table, encoding = 'EUC-KR') %>% 
  html_nodes(., '.Nnavi') %>% 
  html_nodes(., '.pgRR') %>%  
  html_nodes(., 'a') %>%  
  html_attr(., 'href')

library(httr)
library(rvest)


#content > div.section.inner_sub > table.Nnavi > tbody > tr > td.pgRR > a


#//*[@id="content"]/div[2]/table[2]/tbody/tr/td[12]/a
library(readr)
url = 'https://finance.naver.com/item/frgn.nhn?code=043650'
data = GET(url,
           user_agent('Mozilla/5.0 (Windows NT 10.0; Win64; x64)
                      AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.77 Safari/537.36'))


aaa <- read_html(data, encoding = 'EUC-KR') %>% 
  html_node(xpath = '//*[@id="content"]/div[2]/table[2]/tbody/tr/td[12]/a') %>% 
  html_text()
aaa
