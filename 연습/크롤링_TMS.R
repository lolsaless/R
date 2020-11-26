ifelse(!require(rvest), install.packages('rvest'), library(rvest))
ifelse(!require(httr), install.packages('httr'), library(httr))
ifelse(!require(jsonlite), install.packages('jsonlite'), library(jsonlite))

url_tms <- 'https://www.stacknsky.or.kr/stacknsky/selectMeasureResult.do2'
ref_tms <- 'https://www.stacknsky.or.kr/stacknsky/contentsDa.jsp'

year <- as.character(c(2015:2019))
brtcCode <- as.character(c(1:17))
for (i in year) {
  name = i
  for (ii in brtcCode) {
    Code = ii
    data_tms <- POST(url_tms,
                     body = list(year = name,
                                 brtcCode = Code),
                     add_headers(referer = ref_tms))
    
    data_tms <- data_tms %>% content(as='text') %>% fromJSON() %>% do.call(rbind,.)
    write.csv(data_tms, paste0(Code,'_',name,'_tms.csv'))
    Sys.sleep(5.0) 
  }
}

