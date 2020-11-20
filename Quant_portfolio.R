setwd('D:/quant_portfolio')

if(!require(stringr)) {
  install.packages('stringr')
}

#LowPBR
library(stringr)
KOR_ticker = read.csv('KOR_ticker_LowPBR.csv', row.names = 1, stringsAsFactors = FALSE)
KOR_ticker$종목코드 = str_pad(KOR_ticker$'종목코드', 6, 'left', 0)


install.packages("quantmod")
if(!require(xts)) {
  install.packages('xts')
  library(xts)
}


if(!require(httr)) {
  install.packages('httr')
  library(httr)
}

if(!require(rvest)) {
  install.packages('rvest')
  library(rvest)
}

if(!require(readr)) {
  install.packages('readr')
  library(readr)
}

if(!require(lubridate)) {
  install.packages('lubridate')
  library(lubridate)
}



ifelse(dir.exists('KOR_price'), FALSE, dir.create('KOR_price'))
for(i in 1 : nrow(KOR_ticker) ) {
  price = xts(NA, order.by = Sys.Date()) # 빈 시계열 데이터 생성
  name = KOR_ticker$'종목코드'[i] # 티커 부분 선택
  print(name)
  # 오류 발생 시 이를 무시하고 다음 루프로 진행
  tryCatch({
    # url 생성
    url = paste0(
      'https://fchart.stock.naver.com/sise.nhn?symbol=',name,
      '&timeframe=day&count=300&requestType=0')
    # 데이터 다운로드
    data = GET(url)
    data_html = read_html(data, encoding = 'EUC-KR') %>%
      html_nodes("item") %>%
      html_attr("data") 
    # 데이터 나누기
    price = read_delim(data_html, delim = '|')
    # 필요한 열만 선택 후 클렌징
    price = price[c(1, 5)] 
    price = data.frame(price)
    colnames(price) = c('Date', 'Price')
    price[, 1] = ymd(price[, 1])
    rownames(price) = price[, 1]
    price[, 1] = NULL
  }, error = function(e) {
    # 오류 발생시 해당 종목명을 출력하고 다음 루프로 이동
    warning(paste0("Error in Ticker: ", name))
  })
  # 다운로드 받은 파일을 생성한 폴더 내 csv 파일로 저장
  write.csv(price, paste0('KOR_price/', name,'_price.csv'))
  # 타임슬립 적용
  Sys.sleep(0.5)
}

warnings()

#FScore
KOR_ticker = read.csv('KOR_ticker_FScore.csv', row.names = 1, stringsAsFactors = FALSE)
KOR_ticker$종목코드 = str_pad(KOR_ticker$'종목코드', 6, 'left', 0)
ifelse(dir.exists('KOR_price'), FALSE, dir.create('KOR_price'))
for(i in 1 : nrow(KOR_ticker) ) {
  price = xts(NA, order.by = Sys.Date()) # 빈 시계열 데이터 생성
  name = KOR_ticker$'종목코드'[i] # 티커 부분 선택
  print(name)
  # 오류 발생 시 이를 무시하고 다음 루프로 진행
  tryCatch({
    # url 생성
    url = paste0(
      'https://fchart.stock.naver.com/sise.nhn?symbol=',name,
      '&timeframe=day&count=300&requestType=0')
    # 데이터 다운로드
    data = GET(url)
    data_html = read_html(data, encoding = 'EUC-KR') %>%
      html_nodes("item") %>%
      html_attr("data") 
    # 데이터 나누기
    price = read_delim(data_html, delim = '|')
    # 필요한 열만 선택 후 클렌징
    price = price[c(1, 5)] 
    price = data.frame(price)
    colnames(price) = c('Date', 'Price')
    price[, 1] = ymd(price[, 1])
    rownames(price) = price[, 1]
    price[, 1] = NULL
  }, error = function(e) {
    # 오류 발생시 해당 종목명을 출력하고 다음 루프로 이동
    warning(paste0("Error in Ticker: ", name))
  })
  # 다운로드 받은 파일을 생성한 폴더 내 csv 파일로 저장
  write.csv(price, paste0('KOR_price/', name,'_price.csv'))
  # 타임슬립 적용
  Sys.sleep(0.5)
}

#Magic
KOR_ticker = read.csv('KOR_ticker_Magic.csv', row.names = 1, stringsAsFactors = FALSE)
KOR_ticker$종목코드 = str_pad(KOR_ticker$'종목코드', 6, 'left', 0)
ifelse(dir.exists('KOR_price'), FALSE, dir.create('KOR_price'))
for(i in 1 : nrow(KOR_ticker) ) {
  price = xts(NA, order.by = Sys.Date()) # 빈 시계열 데이터 생성
  name = KOR_ticker$'종목코드'[i] # 티커 부분 선택
  print(name)
  # 오류 발생 시 이를 무시하고 다음 루프로 진행
  tryCatch({
    # url 생성
    url = paste0(
      'https://fchart.stock.naver.com/sise.nhn?symbol=',name,
      '&timeframe=day&count=300&requestType=0')
    # 데이터 다운로드
    data = GET(url)
    data_html = read_html(data, encoding = 'EUC-KR') %>%
      html_nodes("item") %>%
      html_attr("data") 
    # 데이터 나누기
    price = read_delim(data_html, delim = '|')
    # 필요한 열만 선택 후 클렌징
    price = price[c(1, 5)] 
    price = data.frame(price)
    colnames(price) = c('Date', 'Price')
    price[, 1] = ymd(price[, 1])
    rownames(price) = price[, 1]
    price[, 1] = NULL
  }, error = function(e) {
    # 오류 발생시 해당 종목명을 출력하고 다음 루프로 이동
    warning(paste0("Error in Ticker: ", name))
  })
  # 다운로드 받은 파일을 생성한 폴더 내 csv 파일로 저장
  write.csv(price, paste0('KOR_price/', name,'_price.csv'))
  # 타임슬립 적용
  Sys.sleep(0.5)
}

#Quality
KOR_ticker = read.csv('KOR_ticker_Quality.csv', row.names = 1, stringsAsFactors = FALSE)
KOR_ticker$종목코드 = str_pad(KOR_ticker$'종목코드', 6, 'left', 0)
ifelse(dir.exists('KOR_price'), FALSE, dir.create('KOR_price'))
for(i in 1 : nrow(KOR_ticker) ) {
  price = xts(NA, order.by = Sys.Date()) # 빈 시계열 데이터 생성
  name = KOR_ticker$'종목코드'[i] # 티커 부분 선택
  print(name)
  # 오류 발생 시 이를 무시하고 다음 루프로 진행
  tryCatch({
    # url 생성
    url = paste0(
      'https://fchart.stock.naver.com/sise.nhn?symbol=',name,
      '&timeframe=day&count=300&requestType=0')
    # 데이터 다운로드
    data = GET(url)
    data_html = read_html(data, encoding = 'EUC-KR') %>%
      html_nodes("item") %>%
      html_attr("data") 
    # 데이터 나누기
    price = read_delim(data_html, delim = '|')
    # 필요한 열만 선택 후 클렌징
    price = price[c(1, 5)] 
    price = data.frame(price)
    colnames(price) = c('Date', 'Price')
    price[, 1] = ymd(price[, 1])
    rownames(price) = price[, 1]
    price[, 1] = NULL
  }, error = function(e) {
    # 오류 발생시 해당 종목명을 출력하고 다음 루프로 이동
    warning(paste0("Error in Ticker: ", name))
  })
  # 다운로드 받은 파일을 생성한 폴더 내 csv 파일로 저장
  write.csv(price, paste0('KOR_price/', name,'_price.csv'))
  # 타임슬립 적용
  Sys.sleep(0.5)
}

#Valuefactor
KOR_ticker = read.csv('KOR_ticker_Valuefactor.csv', row.names = 1, stringsAsFactors = FALSE)
KOR_ticker$종목코드 = str_pad(KOR_ticker$'종목코드', 6, 'left', 0)
ifelse(dir.exists('KOR_price'), FALSE, dir.create('KOR_price'))
for(i in 1 : nrow(KOR_ticker) ) {
  price = xts(NA, order.by = Sys.Date()) # 빈 시계열 데이터 생성
  name = KOR_ticker$'종목코드'[i] # 티커 부분 선택
  print(name)
  # 오류 발생 시 이를 무시하고 다음 루프로 진행
  tryCatch({
    # url 생성
    url = paste0(
      'https://fchart.stock.naver.com/sise.nhn?symbol=',name,
      '&timeframe=day&count=300&requestType=0')
    # 데이터 다운로드
    data = GET(url)
    data_html = read_html(data, encoding = 'EUC-KR') %>%
      html_nodes("item") %>%
      html_attr("data") 
    # 데이터 나누기
    price = read_delim(data_html, delim = '|')
    # 필요한 열만 선택 후 클렌징
    price = price[c(1, 5)] 
    price = data.frame(price)
    colnames(price) = c('Date', 'Price')
    price[, 1] = ymd(price[, 1])
    rownames(price) = price[, 1]
    price[, 1] = NULL
  }, error = function(e) {
    # 오류 발생시 해당 종목명을 출력하고 다음 루프로 이동
    warning(paste0("Error in Ticker: ", name))
  })
  # 다운로드 받은 파일을 생성한 폴더 내 csv 파일로 저장
  write.csv(price, paste0('KOR_price/', name,'_price.csv'))
  # 타임슬립 적용
  Sys.sleep(0.5)
}




############################백테스트############################
if(!require(stringr)){
  install.packages('stringr')
  library(stringr)  
}

KOR_ticker = read.csv('KOR_ticker_LowPBR.csv',
                      row.names = 1,stringsAsFactors = FALSE) 
KOR_ticker$'종목코드' = str_pad(KOR_ticker$'종목코드', 6, 'left', 0)

#모든 종목 주식가격 합치기------
if(!require(xts)){
  install.packages('xts')
  library(xts)  
}


price_list = list()
for (i in 1 : nrow(KOR_ticker)) {
  name = KOR_ticker[i, '종목코드']
  price_list[[i]] =
    read.csv(paste0('KOR_price/', name,'_price.csv'),row.names = 1) %>% as.xts()
}

price_list = do.call(cbind, price_list) %>% na.locf()
colnames(price_list) = KOR_ticker$'종목코드' #tail(price_list,10)

# NA 종가 전날, 다음날 가격의 평균 값으로 보간
aa <- price_list
bb <- na.approx(aa, na.rm = F)
cc <- na.locf(bb, na.rm = F)
dd <- na.locf(cc, fromLast = T)
price_list <- dd

# 백테스트 코드 : 매수 후 보유 전략

#### 백테스트 기간 설정 2가지 방법. 둘 중에 하나만 사용하세요 #####
#1 백테스트 할 기간 지정
backtest_period = 247 # 1년 은 247일로 지정하면 됨
# 종목별 종가가격 dataframe의 1년전 날짜부터 남기기
backtest_price_list = tail(price_list,backtest_period) 

# #2 백테스트 시작할 날짜 지정
# backtest_StartDate = "2019-01-01 KST" # 백테스트 시작할 날짜 지정 , 형식을 꼭 지켜주세요.
# backtest_StartDate_i = max(which(index(price_list)<=backtest_StartDate)) # 시작할 날짜의 행 순서 값
# backtest_price_list = tail(price_list,nrow(price_list)-backtest_StartDate_i)
##############################################################

#### 설정 변수 지정  #####
tuja_n = nrow(KOR_ticker) #매수할 최대 종목 수 지정 : 50종목
seedmoney = 10000000 #초기 투자 금액 : 1천만원
#종목 당 최대 매수 금액 : 1천만원 / 50종목 = 20만원
tuja_max_price = seedmoney / tuja_n 
wt_j = rep(0, tuja_n) #종목보유현황 저장 배열
wt_each_sum = rep(0,tuja_n) #종목별 현재평가액(종목수*현재가) 저장 배열
wt_each_buysum = rep(0,tuja_n) #종목별 초기 매입가 저장 배열
wt_each_n = rep(0,tuja_n) #종목별 매수 수량 저장 배열
jango = seedmoney # 매수 후 남은 계좌의 잔고
allsumprice = jango #계좌 전체 평가액

mymoney = list() # 일자별 계좌 평가액(잔고+종목별평가금액)
mymoney[[1]] = seedmoney # 백테스트 첫날 평가액은 초기투자금액으로 지정
##############################################################


#### 백테스트 시작 #####
for (i in 1 : nrow(backtest_price_list)) { 
  print(paste0('평가일 :',index(backtest_price_list[i,]))) # 평가 날짜 표시
  #계좌평가 
  if(i!=1){ #백테스트 시작일은 평가하지 않음. 매수만 하기 때문
    for(m in 1:tuja_n){ #최대 보유 종목 수 만큼
      if(wt_j[m]>0) { #종목을 보유하고 있다면
        # 보유 수량 * 현재가 를 종목별 평가 금액으로 업데이트
        wt_each_sum[m]=wt_each_n[m]*backtest_price_list[i,wt_j[m]]
      }
    }
    #모든 종복의 평가 금액의 합 + 잔고 를 전체 평가 금액으로 업데이트
    allsumprice = sum(wt_each_sum)+jango 
    
    print(paste0('투자금액= ',sum(wt_each_buysum),
                 ' 잔고=',jango,
                 ' 계좌 평가 금액=', allsumprice))
    
    mymoney[[i]] = allsumprice # 일자별 평가 금액 업데이트
  }
  
  jj=1 #보유종목현황 인덱스
  for ( column in 1 : tuja_n) { # 최대 보유 종목 수(tuja_n) 만큼 종목 매수 : 50종목
    
    # wt_j는 현재 매수한 종목의 컬럼을 저장하고 있다. 0이면 아직 매수 전이라는 뜻
    # jango(현재계좌투자가능금액)가 한 종목당 매수 최대 금액(tuja_max_price)보다 커야 매수할 수 있음
    if(wt_j[jj]==0 && jango >= tuja_max_price){ 
      wt_j[jj] = column # 보유종목현황에 컬럼 넘버를 지정
      
      # 현재가로 매수할 수 있는 매수수량 계산, i는 현재 백테스트 날짜
      wt_each_n[jj] = floor(tuja_max_price/backtest_price_list[i,column])
      
      # 매수 합계 계산 = 매수 수량 * 현재가
      wt_each_buysum[jj] = wt_each_n[jj] * backtest_price_list[i,column]
      
      # 잔고에서 매수금액 뺀 값을 업데이트
      jango = jango - wt_each_buysum[jj]
      
      print(paste0('매수 ', jj,
                   ' 종목 ', KOR_ticker$종목명[column],
                   ' 가격 ', backtest_price_list[i,column], 
                   ' 수 ', wt_each_n[jj], 
                   ' 매수합계 ', wt_each_buysum[jj]  ))
      
      #allsumprice = sum(wt_each_sum)+jango
      print(paste0(' 잔고 ', jango, ' 계좌 평가 금액', allsumprice ))
    }
    jj=jj+1
  }
}
#---------

##### 백테스트 결과 챠트 그리기 ####
if(!require(plotly)){
  install.packages('plotly')
  library(plotly)  
}


chart <- data.frame(date = index(backtest_price_list))
chart$저PBR <- data.frame(matrix(unlist(mymoney), 
                                nrow=length(mymoney)))[,]

p <- plot_ly(chart, x = ~date, y = ~저PBR, 
             name='매수후보유_저PBR', type = 'scatter',
             mode = 'lines') %>%
  layout( title = "백테스트 결과")

ggplotly(p)
###################################
