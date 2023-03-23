#C:\Users\HooF\Documents\GitHub\R_coding\Rselenium java -Dwebdriver.gecko.driver="geckodriver" -jar selenium-server-standalone-4.0.0-alpha-2.jar -port 4445

library(RSelenium)
library(rvest)
library(httr)
library(tidyverse)
library(xml2)

remDr = remoteDriver(
    remoteServerAddr = "localhost",
    port = 4445L,
    browserName = "chrome"
)

remDr$open()
url <- "https://www.foodsafetykorea.go.kr/portal/specialinfo/searchInfoProduct.do?menu_grp=MENU_NEW04&menu_no=2815"
remDr$navigate(url)

Search_btn <- remDr$findElement(using = "xpath", value = "//*[@id='srchBtn']")
Search_bar <- remDr$findElement(using = "xpath", value = "//*[@id='prd_cd_nm']")
Search_bar$setElementAttribute("value", "혼합음료")
Search_btn$clickElement()

#for 반복문으로 2815#page1 ~ 2815#page612
for (i in 1:612) {
    print(paste0(i,"페이지"))
    for (j in 1:10) {
        print(paste0(j,"링크 크롤링 중"))
        Sys.sleep(1)
    }
    Sys.sleep(10)
}

#next page
click_next <- remDr$findElement(using = "xpath", value = '//*[@id="contents"]/main/section/div[2]/div[3]/div/ul/li[7]/a')
click_next$clickElement()

#page 정보
page_html <- remDr$getPageSource()[[1]] %>%
    read_html() %>% html_table(fill = TRUE)
df_page_html <- as.data.frame(page_html)


#id 정보
id <- remDr$getPageSource()[[1]] %>% 
    read_html() %>% 
    html_nodes('tr') %>% 
    html_nodes(".table_txt") %>% 
    html_nodes("a") %>% 
    html_attr("id")

str(id)
id[1]
id[10]

id[1]
id_xpath <- paste0("//*[@id=", id[1], "]")


#id링크 접속, table 정보
title <- remDr$findElement(using = "xpath", value = id_xpath)
title$clickElement()
title_inf <- remDr$getPageSource()[[1]] %>% read_html() %>% 
    html_table(fill = TRUE)
title_inf[[3]]
df_title_inf <- title_inf[[3]]
df_title_inf[1,2]


df_list <- data.frame()
df_list <- list()

library(tidyverse)

print(mpg)

mpg

mpg[1,]
nrow(mpg)


for (i in 1:nrow(mpg)) {
    df_list[i,] = mpg[i,]
}


