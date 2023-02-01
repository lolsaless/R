#작업공간 우선 지정
setwd('D:\\')
ifelse(dir.exists('r_data'), FALSE, dir.create('r_data'))
setwd('D:\\r_data')

#데이터 크롤링을 위한 필수 라이브러리 설치
ifelse(!require(rvest), install.packages('rvest'), library(rvest))
ifelse(!require(httr), install.packages('httr'), library(httr))
ifelse(!require(jsonlite), install.packages('jsonlite'), library(jsonlite))

#크롤링하고자 하는 사이트의 주소와 크롤링 할 때 필요한 흔적(?)남기기 위한 http리퍼러
url_tms <- 'https://www.stacknsky.or.kr/stacknsky/selectMeasureResult.do2'
ref_tms <- 'https://www.stacknsky.or.kr/stacknsky/contentsDa.jsp'

#위 사이트는 POST방식이며, body 부분에 들어갈 년도와 코드
year <- as.character(c(2015:2019))
code <- as.character(c(1:17))
#지역구분 코드표
df.code = data.frame(num = c(1:17),
                     city = c('서울', '부산', '대구', '인천','광주', '대전', '울산', '경기','강원', '충북','충남', '전북', '전남', '경북','경남', '제주', '세종'))

#POST 함수를 이용하여, url 부분에 우리가 크롤링하고자 하는 주소 (url_tms에 할당)를 입력
#body 부분에 list형태로 년도, 코드 입력. data_tms에 할당
#데이터를 text로 전환 %>% JSON코드를 읽어내고, do.call(rbind,.)함수를 이용하여, 행형태로 bind한다.
#for 구문 i 다음 다시 for 구문 i를 하는 이유는
#for 구문은 i에 할당된 개수 만큼 반복한다. year에는 2015:2019까지 5개가 할당되어 있어 5번 실행되고 종료한다.
#우리가 찾고자 하는 지역은 17개 이므로, for ii를 추가 반복문을 실행하게 된다.
# 1cycle = 2015 1, 2015 2..... 2015 17
# 2cycle = 2016 1, 2016 2..... 2016 17
# 최종 2019 17까지 반복을 하게 된다.
ifelse(dir.exists('data_tms'), FALSE, dir.create('data_tms'))
for (i in year) {
    for (ii in code) {
        data_tms <- POST(url_tms,
                         body = list(year = i,
                                     brtcCode = ii),
                         add_headers(referer = ref_tms))
        
        data_tms <- data_tms %>% content(as='text') %>% fromJSON() %>% do.call(rbind,.)
        
        for (iii in df.code$num) {
            if (ii == iii){
                write.csv(data_tms, paste0('data_tms/', i, '_', df.code$city[[iii]],'.csv'))
            }
        }
    }
    Sys.sleep(5.0)  #너무 빠르게 할 경우 자료를 다 처리 못하거나, 디도스로 의심될 수 있음.
}

#년도, 지역명으로 csv파일이 생성된다.

##데이터 취합하기##
#data_tms/ 폴더에 있는 파일의 개수를 구한다.(그만큼 반복작업을 하기 위해서)
tms_len <- length(list.files('data_tms/'))
#tms자료를 취합하기위한 빈 list() 혹은 data.frame() 생성(list로 작업하여, rbind가 data.frame형태로 변환시킴)
tms_data <- data.frame()
#data_tms/ 폴더에 있는 파일의 list를 불러온다
#'2015_강원.csv' .... 형태
tms_list <- list.files('data_tms/')

#rbind 함수는 데이터를 적재한다.
#빈 data.frame인 tms_data에 첫 번째 csv파일이 불러와지고
#rbind로 tms_data에 csv를 적재
#for문이 돌면서 다시 두 번째 csv파일을 불러오고
#첫 번재 데이터가 적재된 tms_data에 두 번째 csv파일이 적재된다.
#이렇게 1~파일개수까지 반복작업
for (i in 1:tms_len) {
    temp <- read.csv(paste0('data_tms/', tms_list[i]))
    tms_data <- rbind(tms_data, temp)
}

library(dplyr)
head(tms_data)
tms_data = tms_data[!(tms_data$X == 'year'), ]
tms_data = tms_data[!(tms_data$X == 'brtcCode'), ]
tms_data = tms_data[!(tms_data$X == 'result'), ]
tms_data = tms_data %>% select(-c(1,2,11))
tms_data = tms_data[ , c(4,5,2,1,3,9,8,6,7)]
head(tms_data)
colnames(tms_data) = c('년도', '시설명', '주소', '먼지', '황산화물', '질소산화물', '일산화탄소', '염화수소', 'Code')
rownames(tms_data) = NULL


write.csv(tms_data, 'tms_data.csv')
