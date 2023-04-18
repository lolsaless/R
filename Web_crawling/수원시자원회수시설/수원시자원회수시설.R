library(httr)
library(rvest)
library(tidyverse)

url <- 'http://www.rrfsuwon.co.kr/_Skin/24_1.php'

data <- POST(url, body = list(
  gubun = 'period',
  sYear = '2020',
  sMonth = '10',
  sDate = '2010-01-01',
  eDate = '2023-04-17'
))

data_suwon <- read_html(data) %>% html_table(fill = T) %>% .[[1]]


# Create a vector of keywords to be removed in Korean
keywords <- c("일자", "최대", "최소", "평균", "합계")

# Use subset function to select rows that do not contain any of the keywords
data_suwon <- subset(data_suwon, !apply(data_suwon, 1,
                                        function(x) any(grepl(paste(keywords, collapse = "|"),
                                                              gsub("[^[:alpha:]]", " ", x)))))

# subset() 함수는 조건에 따라 data_suwon 데이터 프레임을 부분 집합화하는 데 사용됩니다.
# 조건은 부정 연산자 !를 사용하여 지정된 한국어 키워드가 포함되지 않은 행만 선택하도록 지정합니다.
# apply() 함수는 데이터 프레임의 각 행에 함수를 적용하는 데 사용됩니다. 1 인수는 함수가 각 행에 적용되어야 함을 지정합니다.
# 각 행에 적용되는 함수는 function() 키워드를 사용하여 정의합니다. 인수 x는 데이터 프레임의 각 행을 나타냅니다.
# grepl() 함수는 데이터 프레임의 각 행에 연결된 한국어 키워드가 있는지 확인하는 데 사용됩니다. paste() 함수는 키워드를 전체 단어로 일치시키는 정규식으로 키워드를 연결합니다. collapse 인수는 키워드 사이에 사용되는 구분 문자를 지정하는 데 사용됩니다.
# gsub() 함수는 각 행의 모든 ​​알파벳이 아닌 문자를 공백으로 대체하는 데 사용됩니다. 이렇게 하면 grepl() 함수가 적용될 때 전체 단어만 일치합니다.
# any() 함수는 연결된 한국어 키워드가 행의 단어와 일치하는지 확인하는 데 사용됩니다.
# 각 행에 한국어 키워드가 포함되어 있는지 여부를 나타내는 결과 논리 벡터는 apply() 함수로 전달되어 각 행이 하위 집합에 포함되어야 하는지 여부를 나타내는 논리 벡터를 반환합니다.
# 'data_suwon' 데이터 프레임의 결과 하위 집합에는 지정된 한국어 키워드가 포함되지 않은 행만 포함됩니다.
# 
# 요약하면 이 코드는 data_suwon 데이터 프레임의 각 행에 한국어 키워드가 행에 있는지 확인하는 함수를 적용합니다. 결과 논리 벡터는 지정된 한국어 키워드를 포함하는 행을 제외하기 위해 데이터 프레임을 부분 집합화하는 데 사용됩니다.

#----날짜 형태 변환----



# base 함수 as.Date를 이용하여 변환
ts_suwon <- data_suwon
ts_suwon$일자<- as.Date(data_suwon$일자, format = "%Y.%m.%d")
str(ts_suwon)
view(ts_suwon)

# lubridate 함수를 이용하여 변환
library(lubridate)
ts_suwon <- data_suwon
ts_suwon$일자 <- ymd(data_suwon$일자)
str(ts_suwon)

# 변수명 변경
names(ts_suwon) <- c("Date", "waste", "Incinerated_waste", "bottom_ash", "fly_ash", "note")
ts_suwon$note <- NULL




# # Create a vector of keywords to be removed in Korean
# keywords <- c("날짜", "최대", "최소", "평균", "합계")
# 
# # Use subset function to select rows that do not contain any of the keywords
# data_suwon <- subset(data_suwon, !apply(data_suwon, 1, function(x) any(grepl(paste0("\\b", keywords, "\\b"), gsub("[^[:alpha:]]", " ", x)))))
# 
# # Display any warning messages generated during the execution of the code
# warnings()

# data_suwon
# 
# data_suwon$일자 <- str_replace_all(data_suwon$일자, '\\.', '')
# data_suwon <- data_suwon[-1,]
# rownames(data_suwon) <- NULL
# data_suwon <- data_suwon[-c(304:307),]
# 
# colnames(data_suwon) <- c('일자', '반입', '소각', '바닥재', '비산재')
# data_suwon <- data_suwon[,-6]
# print(head(data_suwon))
# 
# library(lubridate)
# data_suwon[,1] <- ymd(data_suwon[,1])
# 
# library(timetk)
# i <- data_suwon[,c(1,2)]
# is.data.frame(i)
# 
# ?data.frame
# 
# is.character(data_suwon$일자)
# 
