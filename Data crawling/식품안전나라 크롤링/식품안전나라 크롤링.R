#C:\Users\HooF\Documents\GitHub\R_coding\Rselenium\Windows java -Dwebdriver.gecko.driver="geckodriver" -jar selenium-server-standalone-4.0.0-alpha-2.jar -port 4445

#D:\R_coding\Rselenium\Windows java -Dwebdriver.gecko.driver="geckodriver" -jar selenium-server-standalone-4.0.0-alpha-2.jar -port 4445

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

#Search
Search_btn <- remDr$findElement(using = "xpath", value = "//*[@id='srchBtn']")
Search_bar <- remDr$findElement(using = "xpath", value = "//*[@id='prd_cd_nm']")
Search_bar$setElementAttribute("value", "혼합음료")
Search_btn$clickElement()

#select
click_select1 <- remDr$findElement(using = "xpath", value = '//*[@id="sp_list_cnt"]')
click_select1$clickElement()

click_select2 <- remDr$findElement(using = "xpath", value = '//*[@id="contents"]/main/section/div[2]/div[2]/div[2]/div[5]/ul/li[5]/a')
click_select2$clickElement()


#id 정보 1:123 page 까지, 123번 반복
id <- remDr$getPageSource()[[1]] %>% 
    read_html() %>% 
    html_nodes('tr') %>% 
    html_nodes(".table_txt") %>% 
    html_nodes("a") %>% 
    html_attr("id")

#id path
id_xpath <- paste0("//*[@id=", id[1], "]")


#id링크 접속, table 정보
food_data <- remDr$findElement(using = "xpath", value = id_xpath)
food_data$clickElement()
raw_data <- remDr$getPageSource()[[1]] %>% read_html() %>% html_table(fill = TRUE)

#정보 추출
raw_data[[2]]
raw_data[[6]]

#정렬
temp_list <- c(raw_data[[2]], raw_data[[6]])
temp <- t(unlist(temp_list))
temp <- as.data.frame(temp)

#close
click_close <- remDr$findElement(using = "xpath", value = '//*[@id="close"]')
click_close$clickElement()

#for 반복문
df_temp <- list()
for (i in 1:length(id)) {
    id_xpath <- paste0("//*[@id=", id[i], "]")
    food_data <- remDr$findElement(using = "xpath", value = id_xpath)
    food_data$clickElement()
    Sys.sleep(2)
    raw_data <- remDr$getPageSource()[[1]] %>% read_html() %>% html_table(fill = TRUE)
    
    raw_data[[2]]
    raw_data[[6]]
    
    temp_list <- c(raw_data[[2]], raw_data[[6]])
    temp <- t(unlist(temp_list))
    temp <- as.data.frame(temp)
    
    df_temp[[i]] <- temp
    
    click_close <- remDr$findElement(using = "xpath", value = '//*[@id="close"]')
    click_close$clickElement()
    
    Sys.sleep(2)
}

a <- do.call(bind_rows, df_temp)
view(a)

#next page
click_next <- remDr$findElement(using = "xpath", value = '//*[@id="contents"]/main/section/div[2]/div[3]/div/ul/li[7]/a')
click_next$clickElement()




c <- bind_rows(df_data3, df_data, df_data2)
view(c)

c <- bind_rows(c, temp)

a <- list()

a[[1]] <- temp

a[[2]] <- temp

a[[3]] <- df_data3


view(do.call(bind_rows, a))
