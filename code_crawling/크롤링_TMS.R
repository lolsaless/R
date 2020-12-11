#환경공단에서 제공하는 TMS데이터를 크롤링하기 위한 라이브러리 설치.
ifelse(!require(rvest), install.packages('rvest'), library(rvest))
ifelse(!require(httr), install.packages('httr'), library(httr))
ifelse(!require(jsonlite), install.packages('jsonlite'), library(jsonlite))

#크롤링하고자 하는 사이트의 주소와 크롤링 할 때 필요한 흔적(?)남기기 이한 http리퍼러
url_tms <- 'https://www.stacknsky.or.kr/stacknsky/selectMeasureResult.do2'
ref_tms <- 'https://www.stacknsky.or.kr/stacknsky/contentsDa.jsp'

#위 사이트는 POST방식이며, body 부분에 들어갈 년도와 코드
year <- as.character(c(2015:2019))
code <- as.character(c(1:17))
#지역구분 코드표
df.code = data.frame(num = c(1:17),
                   city = c('서울', '부산', '대구', '인천','광주', '대전', '울산', '경기','강원', '충북','충남', '전북', '전남', '경북','경남', '제주', '세종'))

for (i in year) {
  for (ii in code) {
    data_tms <- POST(url_tms,
                     body = list(year = i,
                                 brtcCode = ii),
                     add_headers(referer = ref_tms))
    
    data_tms <- data_tms %>% content(as='text') %>% fromJSON() %>% do.call(rbind,.)
    
      for (iii in df.code$num) {
        if (ii == iii){
          write.csv(data_tms, paste0(i,'_', df.code$city[[iii]],'.csv'))
      }
    }
  }
  Sys.sleep(5.0)  #너무 빠르게 할 경우 자료를 다 처리 못하거나, 디도스로 의심될 수 있음.
}

#tms자료를 취합하기위한 빈 리스트 생성
#i번째 행에다 하니까 데이터가 신규 데이터로 덮어쓰기가 되어 정상적으로 불러와지지 않는다.
tms_list = list()

for (i in 1:nrow(for_code)) {
  tryCatch({
    name = for_code[i, 'city']
    for(ii in body_year) {
      yy = ii
      
      tms_list[[i]] =
        read.csv(paste0(yy,'_',name,'.csv'))
    }
  }, error = function(e) {
    print(paste('Error:', i))
  })
}

tms_list2 = do.call(rbind, tms_list)



for (i in body_year) {
  print(paste0(i,body_brtcCode))
}
##for문 조건 한 번만 넣어도 해결 될 듯.