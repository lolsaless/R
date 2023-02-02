library(rvest)
library(httr)
library(jsonlite)

#크롤링 할 url 저장
url_air <- 'https://air.gg.go.kr/default/tms.do'
ref_air <- 'https://air.gg.go.kr/default/esData.do?mCode=A010010000'

#body에 들어갈 부분이며, 각 측정 지점의 고유 번호가 저장된 csv파일을 불러온다.
locCd_air <- read.csv('locCd.csv')

#for 구문의 횟수를 저장을 위함.
count = 0 

#for 구문 실행
#typeCd는 데이터의 타입으로 1 = 시간, 2 = 일, 3 = 월, 4 = 년 단위로 데이터 호출

for (i in locCd_air[,1]) {
  count = count + 1
  data_air <- POST(url_air,
                   body = list(op = 'getByLoc',
                               fromDt = '2020-11-17',
                               toDt = '2020-11-17',
                               locCd = i,
                               typeCd = '1'),
                   add_headers(referer = ref_air))
  
  air_gg <- data_air %>% content(as='text') %>% fromJSON() %>% do.call(rbind,.)
  write.csv(air_gg, paste0(i, '_', locCd_air$지역[count], '_', locCd_air$지점[count], '.csv'))
  
  Sys.sleep(5.0)
}
