#C:\Users\HooF\Documents\GitHub\R_coding\Rselenium\Windows java -Dwebdriver.gecko.driver="geckodriver" -jar selenium-server-standalone-4.0.0-alpha-2.jar -port 4445

#D:\R_coding\Rselenium\Windows java -Dwebdriver.gecko.driver="geckodriver" -jar selenium-server-standalone-4.0.0-alpha-2.jar -port 4445

library(RSelenium)
library(rvest)
library(httr)
library(xml2)
library(tidyverse)


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
tryCatch({
    for (page_num in 157:613) {
        
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
            Sys.sleep(4)
            food_data$clickElement()
            Sys.sleep(4)
            
            raw_data <- remDr$getPageSource()[[1]] %>% read_html() %>% html_table(fill = TRUE)
            
            temp_list <- c(raw_data[[2]], raw_data[[6]])
            temp <- t(unlist(temp_list))
            temp <- as.data.frame(temp)
            
            df_temp[[i]] <- temp
            
            click_close <- remDr$findElement(using = "xpath", value = '//*[@id="close"]')
            click_close$clickElement()
            
            Sys.sleep(4)
        }
        
        df_raw_data <- as.data.frame(raw_data[[1]])
        df_data <- do.call(bind_rows, df_temp)
        df_data <- bind_cols(df_raw_data, df_data)
        write.csv(df_data, paste0('drink_page_', page_num, '.csv'), fileEncoding = "UTF-8")
        Sys.sleep(3)
        
        click_next <- remDr$findElement(using = "xpath", value = '//*[@id="contents"]/main/section/div[2]/div[3]/div/ul/li[7]/a')
        click_next$clickElement()
        Sys.sleep(50)
    }
}, error = function(e) {
    warning(paste0("Error: page_", page_num))
})


