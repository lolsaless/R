#C:\Users\HooF\Documents\GitHub\R_coding\Rselenium\Windows java -Dwebdriver.gecko.driver="geckodriver" -jar selenium-server-standalone-4.0.0-alpha-2.jar -port 4445

#D:\R_coding\Rselenium\Windows java -Dwebdriver.gecko.driver="geckodriver" -jar selenium-server-standalone-4.0.0-alpha-2.jar -port 4445

library(RSelenium)
library(rvest)
library(httr)
library(xml2)
library(tidyverse)

crawling_start <- function() {
    
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
    
    Sys.sleep(30)
    
    #폴더 파일개수 산정
    scr_dir <- c("~/R_coding/Data crawling/식품안전나라 크롤링/data")
    scr_file <- list.files(scr_dir)
    scr_cnt <- length(scr_file)
    scr_cnt <- as.numeric(scr_cnt) + 1
    
    #크롤링데이터 저장
    setwd("~/R_coding/Data crawling/식품안전나라 크롤링/data")
    
    #크롤링 페이지 이동
    url2 <- paste0("https://www.foodsafetykorea.go.kr/portal/specialinfo/searchInfoProduct.do?menu_grp=MENU_NEW04&menu_no=2815#page", scr_cnt)
    remDr$navigate(url2)
    
    Sys.sleep(30)
    
    #for 반복문, 크롤링 시작
    for (page_num in scr_cnt:613) {
        
        #data table id가져오기
        id <- remDr$getPageSource()[[1]] %>% 
            read_html() %>% 
            html_nodes('tr') %>% 
            html_nodes(".table_txt") %>% 
            html_nodes("a") %>% 
            html_attr("id")
        
        #임시 list생성
        df_temp <- list()
        
        #for 반복문, id정보 가져오기
        for (i in 1:length(id)) {
            id_xpath <- paste0("//*[@id=", id[i], "]")
            food_data <- remDr$findElement(using = "xpath", value = id_xpath)
            Sys.sleep(1)
            food_data$clickElement()
            
            Sys.sleep(5)
            
            raw_data <- remDr$getPageSource()[[1]] %>% read_html() %>% html_table(fill = TRUE)
            
            temp_list <- c(raw_data[[2]], raw_data[[6]])
            temp <- t(unlist(temp_list))
            temp <- as.data.frame(temp)
            
            df_temp[[i]] <- temp
            
            click_close <- remDr$findElement(using = "xpath", value = '//*[@id="close"]')
            click_close$clickElement()
            
            Sys.sleep(3)
        }
        
        df_raw_data <- as.data.frame(raw_data[[1]])
        df_data <- do.call(bind_rows, df_temp)
        df_data <- bind_cols(df_raw_data, df_data)
        write.csv(df_data, paste0('drink_page_', page_num, '.csv'), fileEncoding = "UTF-8")
        Sys.sleep(3)
        print(paste0(page_num, " page 크롤링 완료"))
        
        #Error확인, 정보 출력
        tryCatch(expr = {
            click_next <- remDr$findElement(using = "xpath", value = '//*[@id="contents"]/main/section/div[2]/div[3]/div/ul/li[7]/a')
            click_next$clickElement()
            Sys.sleep(50)
        }, error = function(e) {
            cat(paste0("Error: page_", page_num))
        })
    }
}

crawling_start()
