#C:\Users\HooF\Documents\GitHub\R_coding\Rselenium\Windows java -Dwebdriver.gecko.driver="geckodriver" -jar selenium-server-standalone-4.0.0-alpha-2.jar -port 4445

#D:\R_coding\Rselenium java -Dwebdriver.gecko.driver="geckodriver" -jar selenium-server-standalone-4.0.0-alpha-2.jar -port 4445

library(RSelenium)
library(rvest)
library(httr)
library(tidyverse)
library(xml2)

#연결
remDr = remoteDriver(
    remoteServerAddr = "localhost",
    port = 4445L,
    browserName = "chrome"
)

#Chrome open
remDr$open()
url <- "https://www.foodsafetykorea.go.kr/portal/specialinfo/searchInfoProduct.do?menu_grp=MENU_NEW04&menu_no=2815"
remDr$navigate(url)

#검색
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
    read_html() %>% 
    html_table(fill = TRUE)

df_page_html <- as.data.frame(page_html)

#id 정보
page_id <- remDr$getPageSource()[[1]] %>% 
    read_html() %>% 
    html_nodes('tr') %>% 
    html_nodes(".table_txt") %>% 
    html_nodes("a") %>% 
    html_attr("id")

page_id[1]
page_id_xpath <- paste0("//*[@id=", page_id[1], "]")
page_id_xpath

#id링크 접속, table 정보
title <- remDr$findElement(using = "xpath", value = page_id_xpath)
title$clickElement()
title_inf <- remDr$getPageSource()[[1]] %>% read_html() %>% 
    html_table(fill = TRUE)

title_data_1 <- as.data.frame(title_inf[[2]])
title_data_2 <- as.data.frame(title_inf[[3]])
title_data_3 <- as.data.frame(title_inf[[6]])


title_data_3 <- title_data_3[ , -3] 
title_data_3 <- title_data_3 %>% gather(key = ingredient, value = item)
title_data_3 %>% spread(ingredient, item)

df_table <- c()
df_table <- title_inf[[2]] %>% select(X2, X4) %>% add_row()

data.frame("a", "b", "c")




df_table[1,3] <- item_2[2,1]
df_table[1,4] <- item_2[2,2]
df_table[1,5] <- item_2[4,1]

item_3 <- title_inf[[6]]
item_3 <- data.frame(item_3)
a <- item_3[1,2]
b <- item_3[2,2]
a
str(a)

item_3

df_table[1,6] <- a
df_table[1,7] <- b

df_table <- df_table %>% rename(manufacture = X2,
                                address = X4,
                                days = ...3,
                                name = ...4,
                                
                                in1 = ...6,
                                in2 = ...7)

df_table <- df_table[-2,]
df_table


list_df <- list()


mpg
list_mpg <- list()

nrow(mpg)

for (i in 1:nrow(mpg)) {
    list_mpg[[i]] <- mpg[i,]
}

a <- do.call(rbind, list_mpg)
a