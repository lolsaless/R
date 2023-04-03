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

#for 반복문
for (page_num in 1:623) {
    
    id <- remDr$getPageSource()[[1]] %>% 
        read_html() %>% 
        html_nodes('tr') %>% 
        html_nodes(".table_txt") %>% 
        html_nodes("a") %>% 
        html_attr("id")
    
    df_temp <- list()
    
    for (i in 1:length(id)) {
        id_xpath <- paste0("//*[@id=", id[i], "]")
        food_data <- remDr$findElement(using = "xpath", value = id_xpath)
        Sys.sleep(3)
        food_data$clickElement()
        Sys.sleep(3)
        
        raw_data <- remDr$getPageSource()[[1]] %>% read_html() %>% html_table(fill = TRUE)
        
        raw_data[[2]]
        raw_data[[6]]
        
        temp_list <- c(raw_data[[2]], raw_data[[6]])
        temp <- t(unlist(temp_list))
        temp <- as.data.frame(temp)
        
        df_temp[[i]] <- temp
        
        click_close <- remDr$findElement(using = "xpath", value = '//*[@id="close"]')
        click_close$clickElement()
        
        Sys.sleep(3)
    }
    
    df_data <- do.call(bind_rows, df_temp)
    write.csv(df_data, paste0('drink_page', page_num, '.csv'))
    Sys.sleep(3)
    
    click_next <- remDr$findElement(using = "xpath", value = '//*[@id="contents"]/main/section/div[2]/div[3]/div/ul/li[7]/a')
    click_next$clickElement()
    Sys.sleep(35)
}
