library(rvest)
library(httr)
library(jsonlite)


##Json코드 크롤링

#사업장대기오염물질관리시스템 TMS 연간 배출량
url_tms <- 'https://www.stacknsky.or.kr/stacknsky/selectMeasureResult.do2'
ref_tms <- 'https://www.stacknsky.or.kr/stacknsky/contentsDa.jsp'

data_tms <- POST(url_tms,
             body = list(year = '2015',
                         brtcCode = '1'),
             add_headers(referer = ref))

data_tms <- data_tms %>% content(as='text') %>% fromJSON() %>% do.call(rbind,.)

#경기도 대기환경정보
url_air <- 'https://air.gg.go.kr/default/tms.do'
ref_air <- 'https://air.gg.go.kr/default/esData.do?mCode=A010010000'

data_air <- POST(url_air,
                 body = list(op = 'getByLoc',
                             fromDt = '2020-11-17',
                             toDt = '2020-11-17',
                             locCd = '131611',
                             typeCd = '1'),
                 add_headers(referer = ref_air))

data_air <- data_air %>% content(as='text') %>% fromJSON() %>% do.call(rbind,.)

