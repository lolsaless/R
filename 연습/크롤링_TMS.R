ifelse(!require(rvest), install.packages('rvest'), library(rvest))
ifelse(!require(httr), install.packages('httr'), library(httr))
ifelse(!require(jsonlite), install.packages('jsonlite'), library(jsonlite))

url_tms <- 'https://www.stacknsky.or.kr/stacknsky/selectMeasureResult.do2'
ref_tms <- 'https://www.stacknsky.or.kr/stacknsky/contentsDa.jsp'

year <- as.character(c(2015:2019))
brtcCode <- as.character(c(1:17))
Codes = data.frame(num = c(1:17),
                   city = c('서울', '부산', '대구', '인천','광주', '대전', '울산', '경기','강원', '충북','충남', '전북',
                         '전남', '경북','경남', '제주', '세종'))
for (i_y in year) {
  years = i_y
  for (i_c in brtcCode) {
    Code = i_c
    data_tms <- POST(url_tms,
                     body = list(year = years,
                                 brtcCode = Code),
                     add_headers(referer = ref_tms))
    
    data_tms <- data_tms %>% content(as='text') %>% fromJSON() %>% do.call(rbind,.)
    
    for (i in Code) {
      for (ii in Codes$num) {
        if (i == ii){
          write.csv(data_tms, paste0(years,'_', Codes$city[[ii]],'.csv'))
        }
      }
    }
    Sys.sleep(5.0)
  }
}