setwd("~/Rcoding")
# 포트폴리오 파일 읽어오기 -----
if(!require(stringr)){
  install.packages('stringr')
  library(stringr)  
}

KOR_ticker = read.csv('Portfolio/마법공식.csv',
                      row.names = 1,stringsAsFactors = FALSE) 
KOR_ticker$'종목코드' = str_pad(KOR_ticker$'종목코드', 6, 'left', 0)

#주가 크롤링 & 저장--------
if(!require(xts)){
  install.packages('xts')
  library(xts)
}
if(!require(httr)){
  install.packages('httr')
  library(httr)
}
if(!require(rvest)){
  install.packages('rvest')
  library(rvest)
}
if(!require(readr)){
  install.packages('readr')
  library(readr)
}
if(!require(lubridate)){
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
      '&timeframe=day&count=900&requestType=0')
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
  Sys.sleep(0.1)
}

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
# #1 백테스트 할 기간 지정
# backtest_period = 247 # 1년 은 247일로 지정하면 됨
# # 종목별 종가가격 dataframe의 1년전 날짜부터 남기기
# backtest_price_list = tail(price_list,backtest_period) 

#2 백테스트 시작할 날짜 지정
backtest_StartDate = "2020-01-01 KST" # 백테스트 시작할 날짜 지정 , 형식을 꼭 지켜주세요.
backtest_StartDate_i = max(which(index(price_list)<=backtest_StartDate)) # 시작할 날짜의 행 순서 값
backtest_price_list = tail(price_list,nrow(price_list)-backtest_StartDate_i)
backtest_period = nrow(backtest_price_list)
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
chart$magic <- data.frame(matrix(unlist(mymoney), 
                                 nrow=length(mymoney)))[,]

### 고가매수저가매도 전략 수정1 최대보유종목 20종목 매수우선순위 적용  ####

## 고가, 저가 판단
maesu_lookback = 10 # 고가라고 판단 할 기간
maedo_lookback = 12 # 저가라고 판단 할 기간

maesu_per = 0.02 # 2%
maedo_per = 0.08 # 8%

#백테스트 시작하는 기간에 고가,저가 판단 기간 추가
priceendp_maesu = backtest_period+maesu_lookback
priceendp_maedo = backtest_period+maedo_lookback
price_list_maesu = tail(price_list,priceendp_maesu) 
price_list_maedo = tail(price_list,priceendp_maedo) 
ep = endpoints(price_list_maesu, on = 'days')
decision_zero = rep(0, nrow(KOR_ticker)) %>% 
  setNames(KOR_ticker$'종목코드')

decision_maesumaedo = list()
decision_maesumaedo_priority = list()

for (day in 1:backtest_period) { #w=maesu_lookback+1 w=priceendp_maesu
  ep_maesu = day+maesu_lookback
  sub_price_list_maesu = price_list_maesu[day:ep_maesu,]
  
  ep_maedo = day+maedo_lookback
  sub_price_list_maedo = price_list_maedo[day:ep_maedo,]
  
  decision = decision_zero
  priority = decision_zero
  
  for (j in 1 : nrow(KOR_ticker)){ #j=1
    endp_maesu = maesu_lookback
    endp_maedo = maedo_lookback
    if(min(ave(sub_price_list_maedo[1:endp_maedo,j]))*(1-maedo_per) > 
       min(sub_price_list_maedo[maedo_lookback+1,j]))
    {
      decision[j] = -2
    }
    else if( max(ave(sub_price_list_maesu[1:endp_maesu,j]))*(1+maesu_per) < 
             max(sub_price_list_maesu[maesu_lookback+1,j]))
    {
      decision[j] = 2
    }
    else
    {
      decision[j] = 0
    }
    avgprice = min(ave(sub_price_list_maesu[1:endp_maesu,j]))
    todayprice = min(sub_price_list_maesu[maesu_lookback+1,j])
    priority[j] = (todayprice-avgprice)/avgprice
  }
  decision_maesumaedo[[day]] = xts(t(decision), order.by = index(backtest_price_list[day]))
  decision_maesumaedo_priority[[day]] = xts(t(priority), order.by = index(backtest_price_list[day]))
}
decision_maesumaedo = do.call(rbind, decision_maesumaedo)
decision_maesumaedo[is.nan(decision_maesumaedo)] <- 0
decision_maesumaedo[is.na(decision_maesumaedo)] <- 0

decision_maesumaedo_priority = do.call(rbind, decision_maesumaedo_priority)
decision_maesumaedo_priority[is.nan(decision_maesumaedo_priority)] <- 0
decision_maesumaedo_priority[is.na(decision_maesumaedo_priority)] <- 0

#### 고가매수저가매도 설정 변수 지정  #####
tuja_n = 20 #매수할 최대 종목 수 지정 : 50종목
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

#### 백테스트 시작 - 고가매수저가매도 #####
for (i in 1 : nrow(backtest_price_list)) { 
  print(paste0('평가일 :',index(backtest_price_list[i,]))) # 평가 날짜 표시
  #계좌평가 & 매도실행
  if(i!=1){ #백테스트 시작일은 평가하지 않음. 매수만 하기 때문
    wt_each_sellsum = rep(0,tuja_n) #매도할 때의 금액
    decision_del_index_maedo = which(decision_maesumaedo[i,]>=0) 
    # 매수매도 신호 순서를 숫자로 변환
    highmomentumm = order(decision_maesumaedo[i,])
    # 0이상값(매수신호,보류신호) 제거
    highmomentumm = highmomentumm[!highmomentumm %in% decision_del_index_maedo] 
    
    for(m in 1:tuja_n){ #최대 보유 종목 수 만큼
      if(wt_j[m]>0) { #종목을 보유하고 있다면
        jongmok = wt_j[m]
        if(jongmok %in% highmomentumm){ #현재 보유 종목이 매도신호 라면
          wt_each_sellsum[m]=wt_each_n[m]*backtest_price_list[i,wt_j[m]]
          print(paste0('매도 ',KOR_ticker$종목명[wt_j[m]],wt_j[m],' 총금액=', wt_each_sellsum[m],
                       ' 매도평가액=', wt_each_sellsum[m]-wt_each_buysum[m]))
          wt_each_buysum[m] = 0
          wt_each_sum[m] = 0
          wt_j[m] = 0
          jango = jango + wt_each_sellsum[m]
        }
        else{ # 매도 대상 종목이 아니라면 보유 수량 * 현재가 를 종목별 평가 금액으로 업데이트
          wt_each_sum[m]=wt_each_n[m]*backtest_price_list[i,wt_j[m]]
        }
      }
    }
    #모든 종복의 평가 금액의 합 + 잔고 를 전체 평가 금액으로 업데이트
    allsumprice = sum(wt_each_sum)+jango 
    
    print(paste0('투자금액= ',sum(wt_each_buysum),
                 ' 잔고=',jango,
                 ' 계좌 평가 금액=', allsumprice))
    
    mymoney[[i]] = allsumprice # 일자별 평가 금액 업데이트
  }
  
  #매수실행 i=50
  decision_del_index_maesu = which(decision_maesumaedo[i,]<=0) #매도,보류 신호
  #highmomentumm = order(decision_maesumaedo[i,]) # 매수매도 신호 순서를 숫자로 변환
  highmomentumm = order(-decision_maesumaedo_priority[i,]) # 평균가 대비 현재가 상승률 높은 순
  highmomentumm = highmomentumm[!highmomentumm %in% decision_del_index_maesu] # 매도,보류 종목 삭제
  highmomentumm = highmomentumm[!highmomentumm %in% wt_j] # 이미 보유 종목은 삭제
  jj = 1 #보유종목현황 인덱스
  momentum_i = 1 #매수신호 종목 리스트 인덱스
  j=0 # 매수신호 종목 인덱스
  
  for ( column in 1 : tuja_n) { # 최대 보유 종목 수(tuja_n) 만큼 종목 매수 : 50종목
    
    if(length(highmomentumm)==0) break #매수할 종목이 없다면 중단
    
    tuja_max_price = jango / (tuja_n-sum(wt_j>0)) #한 종목당 매수 최대 금액 업데이트
    
    # wt_j는 현재 매수한 종목의 컬럼을 저장하고 있다. 0이면 아직 매수 전이라는 뜻
    # jango(현재계좌투자가능금액)가 한 종목당 매수 최대 금액(tuja_max_price)보다 커야 매수할 수 있음
    if(wt_j[jj]==0 && jango >= tuja_max_price){ 
      j = highmomentumm[momentum_i] # 매수신호 종목 
      wt_j[jj] = j # 보유종목현황에 컬럼 넘버를 지정
      
      # 현재가로 매수할 수 있는 매수수량 계산, i는 현재 백테스트 날짜
      wt_each_n[jj] = floor(tuja_max_price/backtest_price_list[i,j])
      
      # 매수 합계 계산 = 매수 수량 * 현재가
      wt_each_buysum[jj] = wt_each_n[jj] * backtest_price_list[i,j]
      
      # 잔고에서 매수금액 뺀 값을 업데이트
      jango = jango - wt_each_buysum[jj]
      
      if(momentum_i==length(highmomentumm)) break #매수신호 종목이 더이상 없다면 중단
      momentum_i = momentum_i + 1
      
      print(paste0('매수 ', jj,
                   ' 종목 ', KOR_ticker$종목명[j],
                   ' 가격 ', backtest_price_list[i,j], 
                   ' 수 ', wt_each_n[jj], 
                   ' 매수합계 ', wt_each_buysum[jj]  ))
      
      #allsumprice = sum(wt_each_sum)+jango
      print(paste0(' 잔고 ', jango, ' 계좌 평가 금액', allsumprice ))
    }
    jj=jj+1
  }
}


chart$고수저도_수정1_20종목_우선순위적용 <- data.frame(matrix(unlist(mymoney),
                                                nrow=length(mymoney)))[,]

########## RSI 높은순위 매수 후 보유 전략
if(!require(TTR)){
  install.packages('TTR')
  library(TTR)  
}


## RSI 63이하 높은순위 매수 / RSI 87 or 92 하락시 매도

rsi_day = 20
rsi_maesu = backtest_period+rsi_day
price_list_rsi = tail(price_list,rsi_maesu) 

decision_zero = rep(0, nrow(KOR_ticker)) %>% 
  setNames(KOR_ticker$'종목코드')

decision_maesumaedo = list()
decision_maesumaedo_priority = list()

for (day in 1:backtest_period) { #w=maesu_lookback+1 w=priceendp_maesu
  
  decision = decision_zero
  priority = decision_zero
  
  for (j in 1 : nrow(KOR_ticker)){ #j=1
    
    ep_rsi_day = day+rsi_day
    rsi <- RSI(price_list_rsi[day:ep_rsi_day,j],n=14)
    rsi_diff = diff(rsi)
    rsi_diff = tail(rsi_diff,1)
    rsi = tail(rsi,1)
    if(is.nan(rsi) || is.nan(rsi_diff))
    {
      rsi = 0
      rsi_diff = 0
    }
    else if((rsi_diff<0 && rsi-rsi_diff>87 && rsi < 87)
            || 
            (rsi_diff<0 && rsi-rsi_diff>92 && rsi < 92))
    {
      decision[j] = -2
    }
    else if(rsi_diff>0 && rsi < 63)
    {
      decision[j] = 2
    }
    
    priority[j] = rsi
  }
  decision_maesumaedo[[day]] = xts(t(decision), order.by = index(backtest_price_list[day]))
  decision_maesumaedo_priority[[day]] = xts(t(priority), order.by = index(backtest_price_list[day]))
}
decision_maesumaedo = do.call(rbind, decision_maesumaedo)
decision_maesumaedo[is.nan(decision_maesumaedo)] <- 0
decision_maesumaedo[is.na(decision_maesumaedo)] <- 0

decision_maesumaedo_priority = do.call(rbind, decision_maesumaedo_priority)
decision_maesumaedo_priority[is.nan(decision_maesumaedo_priority)] <- 0
decision_maesumaedo_priority[is.na(decision_maesumaedo_priority)] <- 0

#### 고가매수저가매도 설정 변수 지정  #####
tuja_n = 20 #매수할 최대 종목 수 지정 : 50종목
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

#### 백테스트 시작 - 고가매수저가매도 #####
for (i in 1 : nrow(backtest_price_list)) { 
  print(paste0('평가일 :',index(backtest_price_list[i,]))) # 평가 날짜 표시
  #계좌평가 & 매도실행
  if(i!=1){ #백테스트 시작일은 평가하지 않음. 매수만 하기 때문
    wt_each_sellsum = rep(0,tuja_n) #매도할 때의 금액
    decision_del_index_maedo = which(decision_maesumaedo[i,]>=0) 
    # 매수매도 신호 순서를 숫자로 변환
    highmomentumm = order(decision_maesumaedo[i,])
    # 0이상값(매수신호,보류신호) 제거
    highmomentumm = highmomentumm[!highmomentumm %in% decision_del_index_maedo] 
    
    for(m in 1:tuja_n){ #최대 보유 종목 수 만큼
      if(wt_j[m]>0) { #종목을 보유하고 있다면
        jongmok = wt_j[m]
        if(jongmok %in% highmomentumm){ #현재 보유 종목이 매도신호 라면
          wt_each_sellsum[m]=wt_each_n[m]*backtest_price_list[i,wt_j[m]]
          print(paste0('매도 ',KOR_ticker$종목명[wt_j[m]],wt_j[m],' 총금액=', wt_each_sellsum[m],
                       ' 매도평가액=', wt_each_sellsum[m]-wt_each_buysum[m]))
          wt_each_buysum[m] = 0
          wt_each_sum[m] = 0
          wt_j[m] = 0
          jango = jango + wt_each_sellsum[m] * 0.99
        }
        else{ # 매도 대상 종목이 아니라면 보유 수량 * 현재가 를 종목별 평가 금액으로 업데이트
          wt_each_sum[m]=wt_each_n[m]*backtest_price_list[i,wt_j[m]]
        }
      }
    }
    #모든 종복의 평가 금액의 합 + 잔고 를 전체 평가 금액으로 업데이트
    allsumprice = sum(wt_each_sum)+jango 
    
    print(paste0('투자금액= ',sum(wt_each_buysum),
                 ' 잔고=',jango,
                 ' 계좌 평가 금액=', allsumprice))
    
    mymoney[[i]] = allsumprice # 일자별 평가 금액 업데이트
  }
  
  #매수실행 i=50
  decision_del_index_maesu = which(decision_maesumaedo[i,]<=0) #매도,보류 신호
  #tail(decision_maesumaedo_priority,1)
  #highmomentumm = order(decision_maesumaedo[i,]) # 매수매도 신호 순서를 숫자로 변환
  highmomentumm = order(-decision_maesumaedo_priority[i,]) # 평균가 대비 현재가 상승률 높은 순
  highmomentumm = highmomentumm[!highmomentumm %in% decision_del_index_maesu] # 매도,보류 종목 삭제
  highmomentumm = highmomentumm[!highmomentumm %in% wt_j] # 이미 보유 종목은 삭제
  jj = 1 #보유종목현황 인덱스
  momentum_i = 1 #매수신호 종목 리스트 인덱스
  j=0 # 매수신호 종목 인덱스
  
  for ( column in 1 : tuja_n) { # 최대 보유 종목 수(tuja_n) 만큼 종목 매수 : 50종목
    
    if(length(highmomentumm)==0) break #매수할 종목이 없다면 중단
    
    tuja_max_price = jango / (tuja_n-sum(wt_j>0)) #한 종목당 매수 최대 금액 업데이트
    
    # wt_j는 현재 매수한 종목의 컬럼을 저장하고 있다. 0이면 아직 매수 전이라는 뜻
    # jango(현재계좌투자가능금액)가 한 종목당 매수 최대 금액(tuja_max_price)보다 커야 매수할 수 있음
    if(wt_j[jj]==0 && jango >= tuja_max_price){ 
      j = highmomentumm[momentum_i] # 매수신호 종목 
      wt_j[jj] = j # 보유종목현황에 컬럼 넘버를 지정
      
      # 현재가로 매수할 수 있는 매수수량 계산, i는 현재 백테스트 날짜
      wt_each_n[jj] = floor(tuja_max_price/backtest_price_list[i,j])
      
      # 매수 합계 계산 = 매수 수량 * 현재가
      wt_each_buysum[jj] = wt_each_n[jj] * backtest_price_list[i,j]
      
      # 잔고에서 매수금액 뺀 값을 업데이트
      jango = jango - wt_each_buysum[jj]
      
      if(momentum_i==length(highmomentumm)) break #매수신호 종목이 더이상 없다면 중단
      momentum_i = momentum_i + 1
      
      print(paste0('매수 ', jj,
                   ' 종목 ', KOR_ticker$종목명[j],
                   ' 가격 ', backtest_price_list[i,j], 
                   ' 수 ', wt_each_n[jj], 
                   ' 매수합계 ', wt_each_buysum[jj],
                   ' RSI ', decision_maesumaedo_priority[i,j]))
      
      #allsumprice = sum(wt_each_sum)+jango
      print(paste0(' 잔고 ', jango, ' 계좌 평가 금액', allsumprice ))
    }
    jj=jj+1
  }
  #print(KOR_ticker$종목명[wt_j])
}


chart$RSI필터고순위매수RSI상하컷매도 <- data.frame(matrix(unlist(mymoney),nrow=length(mymoney)))[,]

## 10일 40일 이동평균 박정석 킬러챠트 매매전략 휴이22님
# https://cafe.naver.com/conerquant/274
# make list
price_list_MA10 = list()
price_list_MA40 = list()

for (i in 1 : nrow(KOR_ticker)) {
  name = KOR_ticker[i, '종목코드']
  price_list_MA10[[i]] = SMA(price_list[,i],n=10)
  #price_list_MA10[[i]] = EMA(price_list[,i],n=10)
  #price_list_MA10[[i]] = WMA(price_list[,i],n=10)
  
  price_list_MA40[[i]] = SMA(price_list[,i],n=40)
  #price_list_MA40[[i]] = EMA(price_list[,i],n=40)
  # price_list_MA40[[i]] = WMA(price_list[,i],n=40)
  
}

price_list_MA10 = do.call(cbind, price_list_MA10) %>% na.locf()
colnames(price_list_MA10) = colnames(price_list)
price_list_MA10 = tail(price_list_MA10,backtest_period) 

price_list_MA40 = do.call(cbind, price_list_MA40) %>% na.locf()
colnames(price_list_MA40) = colnames(price_list)
price_list_MA40 = tail(price_list_MA40,backtest_period) 

decision_zero = rep(0, nrow(KOR_ticker)) %>% 
  setNames(KOR_ticker$'종목코드')

decision_maesumaedo = list()
decision_maesumaedo_priority = list()

for (day in 1:backtest_period) { #w=maesu_lookback+1 w=priceendp_maesu
  
  decision = decision_zero
  priority = decision_zero
  
  for (j in 1 : nrow(KOR_ticker)){ #j=1
    
    if(day > 1){ #day=3
      MA10 = as.numeric(price_list_MA10[day,j])
      MA10_yesterday = as.numeric(price_list_MA10[day-1,j])
      
      MA40 = as.numeric(price_list_MA40[day,j])
      MA40_yesterday = as.numeric(price_list_MA40[day-1,j])
      
      price_now = as.numeric(backtest_price_list[day,j])
      price_yesterday = as.numeric(backtest_price_list[day-1,j])
      
      # 10MA < 40MA 구간 약세 & 40MA가 하락전환 = 매도
      if( MA10 < MA40 && (MA40-MA40_yesterday)<0 )
      {
        decision[j] = -2
        
      } # 10MA > 40MA 구간 강세 & 40MA가 상승전환 = 매수
      else if( MA10 > MA40 &&  (MA40-MA40_yesterday)>0 )
      {
        decision[j] = 2
      }
      
      # 5일 이평선 매도 전략 : 당일주가가 5일이평선 하향돌파 and 이평선 하락 중
      # if( MA5_yesterday > price_now && MA5 < price_now && (price_now-price_yesterday)<0 )
      # {
      #   decision[j] = -2
      #   
      # } # 5일 이평선 매수 전략 : 당일주가가 5일이평선 상향돌파 and 이평선 상승 중
      # else if( MA5_yesterday < price_now &&  MA5 > price_now && (price_now-price_yesterday)>0  )# && rsi >= maedo_proper)#rsi_diff>0 && rsi < 50)
      # {
      #   decision[j] = 2
      # }
      
      
      # if( MA5_yesterday > price_now*0.995 && MA5 < price_now*0.995 && (price_now-price_yesterday)<0 )
      # {
      #   decision[j] = -2
      # 
      # }
      # else if( MA5_yesterday < price_now*1.005 &&  MA5 > price_now*1.005 && (price_now-price_yesterday)>0  )# && rsi >= maedo_proper)#rsi_diff>0 && rsi < 50)
      # {
      #   decision[j] = 2
      # }
      
      
      priority[j] = MA10 - price_now
    }
    else
    {
      decision[j] = 0
      priority[j] = 0
    }
  }
  decision_maesumaedo[[day]] = xts(t(decision), order.by = index(backtest_price_list[day]))
  decision_maesumaedo_priority[[day]] = xts(t(priority), order.by = index(backtest_price_list[day]))
}
decision_maesumaedo = do.call(rbind, decision_maesumaedo)
decision_maesumaedo[is.nan(decision_maesumaedo)] <- 0
decision_maesumaedo[is.na(decision_maesumaedo)] <- 0

decision_maesumaedo_priority = do.call(rbind, decision_maesumaedo_priority)
decision_maesumaedo_priority[is.nan(decision_maesumaedo_priority)] <- 0
decision_maesumaedo_priority[is.na(decision_maesumaedo_priority)] <- 0

tuja_n = 20 #매수할 최대 종목 수 지정 : 50종목
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

#### 백테스트 시작 - 고가매수저가매도 #####
for (i in 1 : nrow(backtest_price_list)) { 
  print(paste0('평가일 :',index(backtest_price_list[i,]))) # 평가 날짜 표시
  #계좌평가 & 매도실행
  if(i!=1){ #백테스트 시작일은 평가하지 않음. 매수만 하기 때문
    wt_each_sellsum = rep(0,tuja_n) #매도할 때의 금액
    decision_del_index_maedo = which(decision_maesumaedo[i,]>=0) 
    # 매수매도 신호 순서를 숫자로 변환
    highmomentumm = order(decision_maesumaedo[i,])
    # 0이상값(매수신호,보류신호) 제거
    highmomentumm = highmomentumm[!highmomentumm %in% decision_del_index_maedo] 
    
    for(m in 1:tuja_n){ #최대 보유 종목 수 만큼
      if(wt_j[m]>0) { #종목을 보유하고 있다면
        jongmok = wt_j[m]
        if(jongmok %in% highmomentumm){ #현재 보유 종목이 매도신호 라면
          wt_each_sellsum[m]=wt_each_n[m]*backtest_price_list[i,wt_j[m]]
          print(paste0('매도 ',KOR_ticker$종목명[wt_j[m]],wt_j[m],' 총금액=', wt_each_sellsum[m],
                       ' 매도평가액=', wt_each_sellsum[m]-wt_each_buysum[m]))
          wt_each_buysum[m] = 0
          wt_each_sum[m] = 0
          wt_j[m] = 0
          jango = jango + wt_each_sellsum[m] * 0.99
        }
        else{ # 매도 대상 종목이 아니라면 보유 수량 * 현재가 를 종목별 평가 금액으로 업데이트
          wt_each_sum[m]=wt_each_n[m]*backtest_price_list[i,wt_j[m]]
        }
      }
    }
    #모든 종복의 평가 금액의 합 + 잔고 를 전체 평가 금액으로 업데이트
    allsumprice = sum(wt_each_sum)+jango 
    
    print(paste0('투자금액= ',sum(wt_each_buysum),
                 ' 잔고=',jango,
                 ' 계좌 평가 금액=', allsumprice))
    
    mymoney[[i]] = allsumprice # 일자별 평가 금액 업데이트
  }
  
  #매수실행 i=50
  decision_del_index_maesu = which(decision_maesumaedo[i,]<=0) #매도,보류 신호
  #tail(decision_maesumaedo_priority,1)
  #highmomentumm = order(decision_maesumaedo[i,]) # 매수매도 신호 순서를 숫자로 변환
  highmomentumm = order(-decision_maesumaedo_priority[i,]) # 평균가 대비 현재가 상승률 높은 순
  highmomentumm = highmomentumm[!highmomentumm %in% decision_del_index_maesu] # 매도,보류 종목 삭제
  highmomentumm = highmomentumm[!highmomentumm %in% wt_j] # 이미 보유 종목은 삭제
  jj = 1 #보유종목현황 인덱스
  momentum_i = 1 #매수신호 종목 리스트 인덱스
  j=0 # 매수신호 종목 인덱스
  
  for ( column in 1 : tuja_n) { # 최대 보유 종목 수(tuja_n) 만큼 종목 매수 : 50종목
    
    if(length(highmomentumm)==0) break #매수할 종목이 없다면 중단
    
    tuja_max_price = jango / (tuja_n-sum(wt_j>0)) #한 종목당 매수 최대 금액 업데이트
    
    # wt_j는 현재 매수한 종목의 컬럼을 저장하고 있다. 0이면 아직 매수 전이라는 뜻
    # jango(현재계좌투자가능금액)가 한 종목당 매수 최대 금액(tuja_max_price)보다 커야 매수할 수 있음
    if(wt_j[jj]==0 && jango >= tuja_max_price){ 
      j = highmomentumm[momentum_i] # 매수신호 종목 
      wt_j[jj] = j # 보유종목현황에 컬럼 넘버를 지정
      
      # 현재가로 매수할 수 있는 매수수량 계산, i는 현재 백테스트 날짜
      wt_each_n[jj] = floor(tuja_max_price/backtest_price_list[i,j])
      
      # 매수 합계 계산 = 매수 수량 * 현재가
      wt_each_buysum[jj] = wt_each_n[jj] * backtest_price_list[i,j]
      
      # 잔고에서 매수금액 뺀 값을 업데이트
      jango = jango - wt_each_buysum[jj]
      
      if(momentum_i==length(highmomentumm)) break #매수신호 종목이 더이상 없다면 중단
      momentum_i = momentum_i + 1
      
      print(paste0('매수 ', jj,
                   ' 종목 ', KOR_ticker$종목명[j],
                   ' 가격 ', backtest_price_list[i,j], 
                   ' 수 ', wt_each_n[jj], 
                   ' 매수합계 ', wt_each_buysum[jj]))
      
      #allsumprice = sum(wt_each_sum)+jango
      print(paste0(' 잔고 ', jango, ' 계좌 평가 금액', allsumprice ))
    }
    jj=jj+1
  }
  #print(KOR_ticker$종목명[wt_j])
}

chart$이동평균10일40일박정석킬러 <- data.frame(matrix(unlist(mymoney),nrow=length(mymoney)))[,]


##### 볼린저밴드 매매전략 ####
price_list_bbands = list()
for (j in 1 : nrow(KOR_ticker)){ #j=1 day=30
  #KOR_ticker$종목명[j]
  
  price = xts(NA, order.by = Sys.Date()) # 빈 시계열 데이터 생성
  name = KOR_ticker$'종목코드'[j] # 티커 부분 선택
  #print(name) #name = '013700'
  # 오류 발생 시 이를 무시하고 다음 루프로 진행
  tryCatch({
    # url 생성
    url = paste0(
      'https://fchart.stock.naver.com/sise.nhn?symbol=',name,
      '&timeframe=day&count=900&requestType=0')
    # 데이터 다운로드
    data = GET(url)
    data_html = read_html(data, encoding = 'EUC-KR') %>%
      html_nodes("item") %>%
      html_attr("data") 
    # 데이터 나누기
    price = read_delim(data_html, delim = '|')
    # 필요한 열만 선택 후 클렌징
    # date, 시가, 고가, 저가, 종가, 거래량
    price = price[c(1,3,4,5)] 
    price = data.frame(price)
    colnames(price) = c('Date', 'high','low','close')
    price[, 1] = ymd(price[, 1])
    rownames(price) = price[, 1]
    price[, 1] = NULL
    price = as.xts(price)
  }, error = function(e) {
    # 오류 발생시 해당 종목명을 출력하고 다음 루프로 이동
    warning(paste0("Error in Ticker: ", name))
  })
  #j=1
  price_list_bbands[j] = list( tail(BBands(price[,c("high","low","close")]),backtest_period) )
  Sys.sleep(0.1)
}

#price_list_bbands = tail(price_list_bbands,backtest_period) 


decision_zero = rep(0, nrow(KOR_ticker)) %>% 
  setNames(KOR_ticker$'종목코드')

decision_maesumaedo = list()
decision_maesumaedo_priority = list()

for (day in 1:backtest_period) { #w=maesu_lookback+1 w=priceendp_maesu
  
  decision = decision_zero
  priority = decision_zero
  
  for (j in 1 : nrow(KOR_ticker)){ #j=1 day=1
    
    if(day!=1){
      price_now = as.numeric(backtest_price_list[day,j])
      price_yesterday = as.numeric(backtest_price_list[day-1,j])
      
      band_up = as.numeric(price_list_bbands[[j]][day,'up'])
      band_ma20 = as.numeric(price_list_bbands[[j]][day,'mavg'])
      band_dn = as.numeric(price_list_bbands[[j]][day,'dn'])
      
      # 오늘 주가가 위 밴드 선 하향돌파시 = 매도
      if( price_now < band_up && price_yesterday > band_up )
      {
        decision[j] = -2
        
      } # 오늘 주가가 아래 밴드 선 상향돌파시 = 매수
      else if( price_now > band_dn &&  price_yesterday< band_dn )
      {
        decision[j] = 2
      }
      
      
      priority[j] = price_now - price_yesterday
    }
    else{
      decision[j] = 0
      priority[j] = 0
    }
    
    
  }
  decision_maesumaedo[[day]] = xts(t(decision), order.by = index(backtest_price_list[day]))
  decision_maesumaedo_priority[[day]] = xts(t(priority), order.by = index(backtest_price_list[day]))
}
decision_maesumaedo = do.call(rbind, decision_maesumaedo)
decision_maesumaedo[is.nan(decision_maesumaedo)] <- 0
decision_maesumaedo[is.na(decision_maesumaedo)] <- 0

decision_maesumaedo_priority = do.call(rbind, decision_maesumaedo_priority)
decision_maesumaedo_priority[is.nan(decision_maesumaedo_priority)] <- 0
decision_maesumaedo_priority[is.na(decision_maesumaedo_priority)] <- 0

tuja_n = 20 #매수할 최대 종목 수 지정 : 50종목
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

#### 백테스트 시작 - 고가매수저가매도
for (i in 1 : nrow(backtest_price_list)) { 
  print(paste0('평가일 :',index(backtest_price_list[i,]))) # 평가 날짜 표시
  #계좌평가 & 매도실행
  if(i!=1){ #백테스트 시작일은 평가하지 않음. 매수만 하기 때문
    wt_each_sellsum = rep(0,tuja_n) #매도할 때의 금액
    decision_del_index_maedo = which(decision_maesumaedo[i,]>=0) 
    # 매수매도 신호 순서를 숫자로 변환
    highmomentumm = order(decision_maesumaedo[i,])
    # 0이상값(매수신호,보류신호) 제거
    highmomentumm = highmomentumm[!highmomentumm %in% decision_del_index_maedo] 
    
    for(m in 1:tuja_n){ #최대 보유 종목 수 만큼
      if(wt_j[m]>0) { #종목을 보유하고 있다면
        jongmok = wt_j[m]
        if(jongmok %in% highmomentumm){ #현재 보유 종목이 매도신호 라면
          wt_each_sellsum[m]=wt_each_n[m]*backtest_price_list[i,wt_j[m]]
          print(paste0('매도 ',KOR_ticker$종목명[wt_j[m]],wt_j[m],' 총금액=', wt_each_sellsum[m],
                       ' 매도평가액=', wt_each_sellsum[m]-wt_each_buysum[m]))
          wt_each_buysum[m] = 0
          wt_each_sum[m] = 0
          wt_j[m] = 0
          jango = jango + wt_each_sellsum[m] * 0.99
        }
        else{ # 매도 대상 종목이 아니라면 보유 수량 * 현재가 를 종목별 평가 금액으로 업데이트
          wt_each_sum[m]=wt_each_n[m]*backtest_price_list[i,wt_j[m]]
        }
      }
    }
    #모든 종복의 평가 금액의 합 + 잔고 를 전체 평가 금액으로 업데이트
    allsumprice = sum(wt_each_sum)+jango 
    
    print(paste0('투자금액= ',sum(wt_each_buysum),
                 ' 잔고=',jango,
                 ' 계좌 평가 금액=', allsumprice))
    
    mymoney[[i]] = allsumprice # 일자별 평가 금액 업데이트
  }
  
  #매수실행 i=50
  decision_del_index_maesu = which(decision_maesumaedo[i,]<=0) #매도,보류 신호
  #tail(decision_maesumaedo_priority,1)
  #highmomentumm = order(decision_maesumaedo[i,]) # 매수매도 신호 순서를 숫자로 변환
  highmomentumm = order(-decision_maesumaedo_priority[i,]) # 평균가 대비 현재가 상승률 높은 순
  highmomentumm = highmomentumm[!highmomentumm %in% decision_del_index_maesu] # 매도,보류 종목 삭제
  highmomentumm = highmomentumm[!highmomentumm %in% wt_j] # 이미 보유 종목은 삭제
  jj = 1 #보유종목현황 인덱스
  momentum_i = 1 #매수신호 종목 리스트 인덱스
  j=0 # 매수신호 종목 인덱스
  
  for ( column in 1 : tuja_n) { # 최대 보유 종목 수(tuja_n) 만큼 종목 매수 : 50종목
    
    if(length(highmomentumm)==0) break #매수할 종목이 없다면 중단
    
    tuja_max_price = jango / (tuja_n-sum(wt_j>0)) #한 종목당 매수 최대 금액 업데이트
    
    # wt_j는 현재 매수한 종목의 컬럼을 저장하고 있다. 0이면 아직 매수 전이라는 뜻
    # jango(현재계좌투자가능금액)가 한 종목당 매수 최대 금액(tuja_max_price)보다 커야 매수할 수 있음
    if(wt_j[jj]==0 && jango >= tuja_max_price){ 
      j = highmomentumm[momentum_i] # 매수신호 종목 
      wt_j[jj] = j # 보유종목현황에 컬럼 넘버를 지정
      
      # 현재가로 매수할 수 있는 매수수량 계산, i는 현재 백테스트 날짜
      wt_each_n[jj] = floor(tuja_max_price/backtest_price_list[i,j])
      
      # 매수 합계 계산 = 매수 수량 * 현재가
      wt_each_buysum[jj] = wt_each_n[jj] * backtest_price_list[i,j]
      
      # 잔고에서 매수금액 뺀 값을 업데이트
      jango = jango - wt_each_buysum[jj]
      
      if(momentum_i==length(highmomentumm)) break #매수신호 종목이 더이상 없다면 중단
      momentum_i = momentum_i + 1
      
      print(paste0('매수 ', jj,
                   ' 종목 ', KOR_ticker$종목명[j],
                   ' 가격 ', backtest_price_list[i,j], 
                   ' 수 ', wt_each_n[jj], 
                   ' 매수합계 ', wt_each_buysum[jj]))
      
      #allsumprice = sum(wt_each_sum)+jango
      print(paste0(' 잔고 ', jango, ' 계좌 평가 금액', allsumprice ))
    }
    jj=jj+1
  }
  #print(KOR_ticker$종목명[wt_j])
}

chart$볼린저밴드매매젼략 <- data.frame(matrix(unlist(mymoney),nrow=length(mymoney)))[,]

## MACD 추세 전략
# make list
price_list_macd = list()
price_list_macd_sig = list()

for (i in 1 : nrow(KOR_ticker)) {
  name = KOR_ticker[i, '종목코드']
  macd =  MACD(price_list[,i], 12, 26, 9, maType="EMA" )
  price_list_macd[[i]] = macd$macd
  price_list_macd_sig[[i]] = macd$signal
}

price_list_macd = do.call(cbind, price_list_macd) %>% na.locf()
colnames(price_list_macd) = colnames(price_list)
price_list_macd = tail(price_list_macd,backtest_period) 

price_list_macd_sig = do.call(cbind, price_list_macd_sig) %>% na.locf()
colnames(price_list_macd_sig) = colnames(price_list)
price_list_macd_sig = tail(price_list_macd_sig,backtest_period) 

decision_zero = rep(0, nrow(KOR_ticker)) %>% 
  setNames(KOR_ticker$'종목코드')

decision_maesumaedo = list()
decision_maesumaedo_priority = list()

for (day in 1:backtest_period) {
  
  decision = decision_zero
  priority = decision_zero
  
  for (j in 1 : nrow(KOR_ticker)){ #j=1
    
    if(day > 1){ #day=3
      macd = as.numeric(price_list_macd[day,j])
      macd_yesterday = as.numeric(price_list_macd[day-1,j])
      
      macd_sig = as.numeric(price_list_macd_sig[day,j])
      macd_sig_yesterday = as.numeric(price_list_macd_sig[day-1,j])
      
      price_now = as.numeric(backtest_price_list[day,j])
      price_yesterday = as.numeric(backtest_price_list[day-1,j])
      
      
      # 매수 조건
      if(macd<0 && macd < macd_sig && macd_yesterday > macd_sig_yesterday)
      {
        decision[j] = -2
        
      } # 매도 조건
      else if(macd>0 && macd > macd_sig && macd_yesterday < macd_sig_yesterday)
      {
        decision[j] = 2
      }
      
      priority[j] = (price_now-price_yesterday)/price_yesterday #상승률
    }
    else
    {
      decision[j] = 0
      priority[j] = 0
    }
  }
  decision_maesumaedo[[day]] = xts(t(decision), order.by = index(backtest_price_list[day]))
  decision_maesumaedo_priority[[day]] = xts(t(priority), order.by = index(backtest_price_list[day]))
}
decision_maesumaedo = do.call(rbind, decision_maesumaedo)
decision_maesumaedo[is.nan(decision_maesumaedo)] <- 0
decision_maesumaedo[is.na(decision_maesumaedo)] <- 0

decision_maesumaedo_priority = do.call(rbind, decision_maesumaedo_priority)
decision_maesumaedo_priority[is.nan(decision_maesumaedo_priority)] <- 0
decision_maesumaedo_priority[is.na(decision_maesumaedo_priority)] <- 0

tuja_n = 20 #매수할 최대 종목 수 지정 : 50종목
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

#### 백테스트 시작 - 고가매수저가매도 #####
for (i in 1 : nrow(backtest_price_list)) { 
  print(paste0('평가일 :',index(backtest_price_list[i,]))) # 평가 날짜 표시
  #계좌평가 & 매도실행
  if(i!=1){ #백테스트 시작일은 평가하지 않음. 매수만 하기 때문
    wt_each_sellsum = rep(0,tuja_n) #매도할 때의 금액
    decision_del_index_maedo = which(decision_maesumaedo[i,]>=0) 
    # 매수매도 신호 순서를 숫자로 변환
    highmomentumm = order(decision_maesumaedo[i,])
    # 0이상값(매수신호,보류신호) 제거
    highmomentumm = highmomentumm[!highmomentumm %in% decision_del_index_maedo] 
    
    for(m in 1:tuja_n){ #최대 보유 종목 수 만큼
      if(wt_j[m]>0) { #종목을 보유하고 있다면
        jongmok = wt_j[m]
        if(jongmok %in% highmomentumm){ #현재 보유 종목이 매도신호 라면
          wt_each_sellsum[m]=wt_each_n[m]*backtest_price_list[i,wt_j[m]]
          print(paste0('매도 ',KOR_ticker$종목명[wt_j[m]],wt_j[m],' 총금액=', wt_each_sellsum[m],
                       ' 매도평가액=', wt_each_sellsum[m]-wt_each_buysum[m]))
          wt_each_buysum[m] = 0
          wt_each_sum[m] = 0
          wt_j[m] = 0
          jango = jango + wt_each_sellsum[m] * 0.99
        }
        else{ # 매도 대상 종목이 아니라면 보유 수량 * 현재가 를 종목별 평가 금액으로 업데이트
          wt_each_sum[m]=wt_each_n[m]*backtest_price_list[i,wt_j[m]]
        }
      }
    }
    #모든 종복의 평가 금액의 합 + 잔고 를 전체 평가 금액으로 업데이트
    allsumprice = sum(wt_each_sum)+jango 
    
    print(paste0('투자금액= ',sum(wt_each_buysum),
                 ' 잔고=',jango,
                 ' 계좌 평가 금액=', allsumprice))
    
    mymoney[[i]] = allsumprice # 일자별 평가 금액 업데이트
  }
  
  #매수실행 i=50
  decision_del_index_maesu = which(decision_maesumaedo[i,]<=0) #매도,보류 신호
  #tail(decision_maesumaedo_priority,1)
  #highmomentumm = order(decision_maesumaedo[i,]) # 매수매도 신호 순서를 숫자로 변환
  highmomentumm = order(-decision_maesumaedo_priority[i,]) # 평균가 대비 현재가 상승률 높은 순
  highmomentumm = highmomentumm[!highmomentumm %in% decision_del_index_maesu] # 매도,보류 종목 삭제
  highmomentumm = highmomentumm[!highmomentumm %in% wt_j] # 이미 보유 종목은 삭제
  jj = 1 #보유종목현황 인덱스
  momentum_i = 1 #매수신호 종목 리스트 인덱스
  j=0 # 매수신호 종목 인덱스
  
  for ( column in 1 : tuja_n) { # 최대 보유 종목 수(tuja_n) 만큼 종목 매수 : 50종목
    
    if(length(highmomentumm)==0) break #매수할 종목이 없다면 중단
    
    tuja_max_price = jango / (tuja_n-sum(wt_j>0)) #한 종목당 매수 최대 금액 업데이트
    
    # wt_j는 현재 매수한 종목의 컬럼을 저장하고 있다. 0이면 아직 매수 전이라는 뜻
    # jango(현재계좌투자가능금액)가 한 종목당 매수 최대 금액(tuja_max_price)보다 커야 매수할 수 있음
    if(wt_j[jj]==0 && jango >= tuja_max_price){ 
      j = highmomentumm[momentum_i] # 매수신호 종목 
      wt_j[jj] = j # 보유종목현황에 컬럼 넘버를 지정
      
      # 현재가로 매수할 수 있는 매수수량 계산, i는 현재 백테스트 날짜
      wt_each_n[jj] = floor(tuja_max_price/backtest_price_list[i,j])
      
      # 매수 합계 계산 = 매수 수량 * 현재가
      wt_each_buysum[jj] = wt_each_n[jj] * backtest_price_list[i,j]
      
      # 잔고에서 매수금액 뺀 값을 업데이트
      jango = jango - wt_each_buysum[jj]
      
      if(momentum_i==length(highmomentumm)) break #매수신호 종목이 더이상 없다면 중단
      momentum_i = momentum_i + 1
      
      print(paste0('매수 ', jj,
                   ' 종목 ', KOR_ticker$종목명[j],
                   ' 가격 ', backtest_price_list[i,j], 
                   ' 수 ', wt_each_n[jj], 
                   ' 매수합계 ', wt_each_buysum[jj]))
      
      #allsumprice = sum(wt_each_sum)+jango
      print(paste0(' 잔고 ', jango, ' 계좌 평가 금액', allsumprice ))
    }
    jj=jj+1
  }
  #print(KOR_ticker$종목명[wt_j])
}

chart$MACD추세전략 <- data.frame(matrix(unlist(mymoney),nrow=length(mymoney)))[,]

##### Slow Stochastic  매매전략 ####
price_list_slowstoch = list()
for (j in 1 : nrow(KOR_ticker)){ #j=1 day=30
  #KOR_ticker$종목명[j]
  
  price = xts(NA, order.by = Sys.Date()) # 빈 시계열 데이터 생성
  name = KOR_ticker$'종목코드'[j] # 티커 부분 선택
  #print(name) #name = '013700'
  # 오류 발생 시 이를 무시하고 다음 루프로 진행
  tryCatch({
    # url 생성
    url = paste0(
      'https://fchart.stock.naver.com/sise.nhn?symbol=',name,
      '&timeframe=day&count=900&requestType=0')
    # 데이터 다운로드
    data = GET(url)
    data_html = read_html(data, encoding = 'EUC-KR') %>%
      html_nodes("item") %>%
      html_attr("data") 
    # 데이터 나누기
    price = read_delim(data_html, delim = '|')
    # 필요한 열만 선택 후 클렌징
    # date, 시가, 고가, 저가, 종가, 거래량
    price = price[c(1,3,4,5)] 
    price = data.frame(price)
    colnames(price) = c('Date', 'high','low','close')
    price[, 1] = ymd(price[, 1])
    rownames(price) = price[, 1]
    price[, 1] = NULL
    price = as.xts(price)
    price <- na.omit(price) # NA 제거
    price <- price[!(price$high == 0 ), ]
  }, error = function(e) {
    # 오류 발생시 해당 종목명을 출력하고 다음 루프로 이동
    warning(paste0("Error in Ticker: ", name))
  })
  #j=1
  price_list_slowstoch[j] = list( tail(stoch(price[,c("high","low","close")]),backtest_period) )
  Sys.sleep(0.1)
}

#price_list_slowstoch = tail(price_list_slowstoch,backtest_period) 


decision_zero = rep(0, nrow(KOR_ticker)) %>% 
  setNames(KOR_ticker$'종목코드')

decision_maesumaedo = list()
decision_maesumaedo_priority = list()

for (day in 1:backtest_period) { #w=maesu_lookback+1 w=priceendp_maesu
  
  decision = decision_zero
  priority = decision_zero
  
  for (j in 1 : nrow(KOR_ticker)){ #j=1 day=1
    
    if(day!=1){
      price_now = as.numeric(backtest_price_list[day,j])
      price_yesterday = as.numeric(backtest_price_list[day-1,j])
      
      slowK = as.numeric(price_list_slowstoch[[j]][day,'fastD'])
      slowK_yesterday = as.numeric(price_list_slowstoch[[j]][day-1,'fastD'])
      slowD = as.numeric(price_list_slowstoch[[j]][day,'slowD'])
      slowD_yesterday = as.numeric(price_list_slowstoch[[j]][day-1,'slowD'])
      
      
      # slowK가 slowD 선 하향돌파시 = 매도
      if(slowK_yesterday>0.8 
         && slowK < slowD 
         && slowK_yesterday > slowD_yesterday )
      {
        decision[j] = -2
        
      } # slowK가 slowD 선 상향돌파시 = 매수
      else if( slowK_yesterday<0.2 
               && slowK > slowD 
               &&  slowK_yesterday < slowD_yesterday )
      {
        decision[j] = 2
      }
      
      
      priority[j] = price_now - price_yesterday
    }
    else{
      decision[j] = 0
      priority[j] = 0
    }
    
    
  }
  decision_maesumaedo[[day]] = xts(t(decision), order.by = index(backtest_price_list[day]))
  decision_maesumaedo_priority[[day]] = xts(t(priority), order.by = index(backtest_price_list[day]))
}
decision_maesumaedo = do.call(rbind, decision_maesumaedo)
decision_maesumaedo[is.nan(decision_maesumaedo)] <- 0
decision_maesumaedo[is.na(decision_maesumaedo)] <- 0

decision_maesumaedo_priority = do.call(rbind, decision_maesumaedo_priority)
decision_maesumaedo_priority[is.nan(decision_maesumaedo_priority)] <- 0
decision_maesumaedo_priority[is.na(decision_maesumaedo_priority)] <- 0

tuja_n = 20 #매수할 최대 종목 수 지정 : 50종목
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

#### 백테스트 시작 - 고가매수저가매도
for (i in 1 : nrow(backtest_price_list)) { 
  print(paste0('평가일 :',index(backtest_price_list[i,]))) # 평가 날짜 표시
  #계좌평가 & 매도실행
  if(i!=1){ #백테스트 시작일은 평가하지 않음. 매수만 하기 때문
    wt_each_sellsum = rep(0,tuja_n) #매도할 때의 금액
    decision_del_index_maedo = which(decision_maesumaedo[i,]>=0) 
    # 매수매도 신호 순서를 숫자로 변환
    highmomentumm = order(decision_maesumaedo[i,])
    # 0이상값(매수신호,보류신호) 제거
    highmomentumm = highmomentumm[!highmomentumm %in% decision_del_index_maedo] 
    
    for(m in 1:tuja_n){ #최대 보유 종목 수 만큼
      if(wt_j[m]>0) { #종목을 보유하고 있다면
        jongmok = wt_j[m]
        if(jongmok %in% highmomentumm){ #현재 보유 종목이 매도신호 라면
          wt_each_sellsum[m]=wt_each_n[m]*backtest_price_list[i,wt_j[m]]
          print(paste0('매도 ',KOR_ticker$종목명[wt_j[m]],wt_j[m],' 총금액=', wt_each_sellsum[m],
                       ' 매도평가액=', wt_each_sellsum[m]-wt_each_buysum[m]))
          wt_each_buysum[m] = 0
          wt_each_sum[m] = 0
          wt_j[m] = 0
          jango = jango + wt_each_sellsum[m] * 0.99
        }
        else{ # 매도 대상 종목이 아니라면 보유 수량 * 현재가 를 종목별 평가 금액으로 업데이트
          wt_each_sum[m]=wt_each_n[m]*backtest_price_list[i,wt_j[m]]
        }
      }
    }
    #모든 종복의 평가 금액의 합 + 잔고 를 전체 평가 금액으로 업데이트
    allsumprice = sum(wt_each_sum)+jango 
    
    print(paste0('투자금액= ',sum(wt_each_buysum),
                 ' 잔고=',jango,
                 ' 계좌 평가 금액=', allsumprice))
    
    mymoney[[i]] = allsumprice # 일자별 평가 금액 업데이트
  }
  
  #매수실행 i=50
  decision_del_index_maesu = which(decision_maesumaedo[i,]<=0) #매도,보류 신호
  #tail(decision_maesumaedo_priority,1)
  #highmomentumm = order(decision_maesumaedo[i,]) # 매수매도 신호 순서를 숫자로 변환
  highmomentumm = order(-decision_maesumaedo_priority[i,]) # 평균가 대비 현재가 상승률 높은 순
  highmomentumm = highmomentumm[!highmomentumm %in% decision_del_index_maesu] # 매도,보류 종목 삭제
  highmomentumm = highmomentumm[!highmomentumm %in% wt_j] # 이미 보유 종목은 삭제
  jj = 1 #보유종목현황 인덱스
  momentum_i = 1 #매수신호 종목 리스트 인덱스
  j=0 # 매수신호 종목 인덱스
  
  for ( column in 1 : tuja_n) { # 최대 보유 종목 수(tuja_n) 만큼 종목 매수 : 50종목
    
    if(length(highmomentumm)==0) break #매수할 종목이 없다면 중단
    
    tuja_max_price = jango / (tuja_n-sum(wt_j>0)) #한 종목당 매수 최대 금액 업데이트
    
    # wt_j는 현재 매수한 종목의 컬럼을 저장하고 있다. 0이면 아직 매수 전이라는 뜻
    # jango(현재계좌투자가능금액)가 한 종목당 매수 최대 금액(tuja_max_price)보다 커야 매수할 수 있음
    if(wt_j[jj]==0 && jango >= tuja_max_price){ 
      j = highmomentumm[momentum_i] # 매수신호 종목 
      wt_j[jj] = j # 보유종목현황에 컬럼 넘버를 지정
      
      # 현재가로 매수할 수 있는 매수수량 계산, i는 현재 백테스트 날짜
      wt_each_n[jj] = floor(tuja_max_price/backtest_price_list[i,j])
      
      # 매수 합계 계산 = 매수 수량 * 현재가
      wt_each_buysum[jj] = wt_each_n[jj] * backtest_price_list[i,j]
      
      # 잔고에서 매수금액 뺀 값을 업데이트
      jango = jango - wt_each_buysum[jj]
      
      if(momentum_i==length(highmomentumm)) break #매수신호 종목이 더이상 없다면 중단
      momentum_i = momentum_i + 1
      
      print(paste0('매수 ', jj,
                   ' 종목 ', KOR_ticker$종목명[j],
                   ' 가격 ', backtest_price_list[i,j], 
                   ' 수 ', wt_each_n[jj], 
                   ' 매수합계 ', wt_each_buysum[jj]))
      
      #allsumprice = sum(wt_each_sum)+jango
      print(paste0(' 잔고 ', jango, ' 계좌 평가 금액', allsumprice ))
    }
    jj=jj+1
  }
  #print(KOR_ticker$종목명[wt_j])
}

chart$SlowStochastic젼략 <- data.frame(matrix(unlist(mymoney),nrow=length(mymoney)))[,]

##### Slow Stochastic 추세(macd) 매매전략 ####
price_list_slowstoch = list()
for (j in 1 : nrow(KOR_ticker)){ #j=1 day=30
  #KOR_ticker$종목명[j]
  
  price = xts(NA, order.by = Sys.Date()) # 빈 시계열 데이터 생성
  name = KOR_ticker$'종목코드'[j] # 티커 부분 선택
  #print(name) #name = '013700'
  # 오류 발생 시 이를 무시하고 다음 루프로 진행
  tryCatch({
    # url 생성
    url = paste0(
      'https://fchart.stock.naver.com/sise.nhn?symbol=',name,
      '&timeframe=day&count=900&requestType=0')
    # 데이터 다운로드
    data = GET(url)
    data_html = read_html(data, encoding = 'EUC-KR') %>%
      html_nodes("item") %>%
      html_attr("data") 
    # 데이터 나누기
    price = read_delim(data_html, delim = '|')
    # 필요한 열만 선택 후 클렌징
    # date, 시가, 고가, 저가, 종가, 거래량
    price = price[c(1,3,4,5)] 
    price = data.frame(price)
    colnames(price) = c('Date', 'high','low','close')
    price[, 1] = ymd(price[, 1])
    rownames(price) = price[, 1]
    price[, 1] = NULL
    price = as.xts(price)
    price <- na.omit(price) # NA 제거
    price <- price[!(price$high == 0 ), ]
  }, error = function(e) {
    # 오류 발생시 해당 종목명을 출력하고 다음 루프로 이동
    warning(paste0("Error in Ticker: ", name))
  })
  #j=1
  price_list_slowstoch[j] = list( tail(stoch(price[,c("high","low","close")]),backtest_period) )
  Sys.sleep(0.1)
}

price_list_macd = list()
for (i in 1 : nrow(KOR_ticker)) {
  macd =  MACD(price_list[,i], 12, 26, 9, maType="EMA" )
  price_list_macd[[i]] = macd$macd
}

price_list_macd = do.call(cbind, price_list_macd) %>% na.locf()
colnames(price_list_macd) = colnames(price_list)
price_list_macd = tail(price_list_macd,backtest_period) 

decision_zero = rep(0, nrow(KOR_ticker)) %>% 
  setNames(KOR_ticker$'종목코드')

decision_maesumaedo = list()
decision_maesumaedo_priority = list()

for (day in 1:backtest_period) { #w=maesu_lookback+1 w=priceendp_maesu
  
  decision = decision_zero
  priority = decision_zero
  
  for (j in 1 : nrow(KOR_ticker)){ #j=1 day=2
    
    if(day!=1){
      price_now = as.numeric(backtest_price_list[day,j])
      price_yesterday = as.numeric(backtest_price_list[day-1,j])
      
      slowK = as.numeric(price_list_slowstoch[[j]][day,'fastD'])
      slowK_yesterday = as.numeric(price_list_slowstoch[[j]][day-1,'fastD'])
      slowD = as.numeric(price_list_slowstoch[[j]][day,'slowD'])
      slowD_yesterday = as.numeric(price_list_slowstoch[[j]][day-1,'slowD'])
      
      macd = as.numeric(price_list_macd[day,j])
      
      # slowK가 slowD 선 하향돌파시 = 매도
      if(macd<0 
         && slowK_yesterday>0.8
         && slowK < slowD
         && slowK_yesterday > slowD_yesterday )
      {
        decision[j] = -2
      } # slowK가 slowD 선 상향돌파시 = 매수
      else if( macd>0                
               && slowK_yesterday<0.2
               && slowK > slowD
               && slowK_yesterday < slowD_yesterday )
      {
        decision[j] = 2
      }
      
      
      priority[j] = price_now - price_yesterday
    }
    else{
      decision[j] = 0
      priority[j] = 0
    }
    
    
  }
  decision_maesumaedo[[day]] = xts(t(decision), order.by = index(backtest_price_list[day]))
  decision_maesumaedo_priority[[day]] = xts(t(priority), order.by = index(backtest_price_list[day]))
}
decision_maesumaedo = do.call(rbind, decision_maesumaedo)
decision_maesumaedo[is.nan(decision_maesumaedo)] <- 0
decision_maesumaedo[is.na(decision_maesumaedo)] <- 0

decision_maesumaedo_priority = do.call(rbind, decision_maesumaedo_priority)
decision_maesumaedo_priority[is.nan(decision_maesumaedo_priority)] <- 0
decision_maesumaedo_priority[is.na(decision_maesumaedo_priority)] <- 0

tuja_n = 20 #매수할 최대 종목 수 지정 : 50종목
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

#### 백테스트 시작 - 고가매수저가매도
for (i in 1 : nrow(backtest_price_list)) { 
  print(paste0('평가일 :',index(backtest_price_list[i,]))) # 평가 날짜 표시
  #계좌평가 & 매도실행
  if(i!=1){ #백테스트 시작일은 평가하지 않음. 매수만 하기 때문
    wt_each_sellsum = rep(0,tuja_n) #매도할 때의 금액
    decision_del_index_maedo = which(decision_maesumaedo[i,]>=0) 
    # 매수매도 신호 순서를 숫자로 변환
    highmomentumm = order(decision_maesumaedo[i,])
    # 0이상값(매수신호,보류신호) 제거
    highmomentumm = highmomentumm[!highmomentumm %in% decision_del_index_maedo] 
    
    for(m in 1:tuja_n){ #최대 보유 종목 수 만큼
      if(wt_j[m]>0) { #종목을 보유하고 있다면
        jongmok = wt_j[m]
        if(jongmok %in% highmomentumm){ #현재 보유 종목이 매도신호 라면
          wt_each_sellsum[m]=wt_each_n[m]*backtest_price_list[i,wt_j[m]]
          print(paste0('매도 ',KOR_ticker$종목명[wt_j[m]],wt_j[m],' 총금액=', wt_each_sellsum[m],
                       ' 매도평가액=', wt_each_sellsum[m]-wt_each_buysum[m]))
          macd = as.numeric(price_list_macd[i,wt_j[m]])
          print(paste0('macd ',macd))
          wt_each_buysum[m] = 0
          wt_each_sum[m] = 0
          wt_j[m] = 0
          jango = jango + wt_each_sellsum[m] * 0.99
        }
        else{ # 매도 대상 종목이 아니라면 보유 수량 * 현재가 를 종목별 평가 금액으로 업데이트
          wt_each_sum[m]=wt_each_n[m]*backtest_price_list[i,wt_j[m]]
        }
      }
    }
    #모든 종복의 평가 금액의 합 + 잔고 를 전체 평가 금액으로 업데이트
    allsumprice = sum(wt_each_sum)+jango 
    
    print(paste0('투자금액= ',sum(wt_each_buysum),
                 ' 잔고=',jango,
                 ' 계좌 평가 금액=', allsumprice))
    
    mymoney[[i]] = allsumprice # 일자별 평가 금액 업데이트
  }
  
  #매수실행 i=50
  decision_del_index_maesu = which(decision_maesumaedo[i,]<=0) #매도,보류 신호
  #tail(decision_maesumaedo_priority,1)
  #highmomentumm = order(decision_maesumaedo[i,]) # 매수매도 신호 순서를 숫자로 변환
  highmomentumm = order(-decision_maesumaedo_priority[i,]) # 평균가 대비 현재가 상승률 높은 순
  highmomentumm = highmomentumm[!highmomentumm %in% decision_del_index_maesu] # 매도,보류 종목 삭제
  highmomentumm = highmomentumm[!highmomentumm %in% wt_j] # 이미 보유 종목은 삭제
  jj = 1 #보유종목현황 인덱스
  momentum_i = 1 #매수신호 종목 리스트 인덱스
  j=0 # 매수신호 종목 인덱스
  
  for ( column in 1 : tuja_n) { # 최대 보유 종목 수(tuja_n) 만큼 종목 매수 : 50종목
    
    if(length(highmomentumm)==0) break #매수할 종목이 없다면 중단
    
    tuja_max_price = jango / (tuja_n-sum(wt_j>0)) #한 종목당 매수 최대 금액 업데이트
    
    # wt_j는 현재 매수한 종목의 컬럼을 저장하고 있다. 0이면 아직 매수 전이라는 뜻
    # jango(현재계좌투자가능금액)가 한 종목당 매수 최대 금액(tuja_max_price)보다 커야 매수할 수 있음
    if(wt_j[jj]==0 && jango >= tuja_max_price){ 
      j = highmomentumm[momentum_i] # 매수신호 종목 
      wt_j[jj] = j # 보유종목현황에 컬럼 넘버를 지정
      
      # 현재가로 매수할 수 있는 매수수량 계산, i는 현재 백테스트 날짜
      wt_each_n[jj] = floor(tuja_max_price/backtest_price_list[i,j])
      
      # 매수 합계 계산 = 매수 수량 * 현재가
      wt_each_buysum[jj] = wt_each_n[jj] * backtest_price_list[i,j]
      
      # 잔고에서 매수금액 뺀 값을 업데이트
      jango = jango - wt_each_buysum[jj]
      
      if(momentum_i==length(highmomentumm)) break #매수신호 종목이 더이상 없다면 중단
      momentum_i = momentum_i + 1
      
      print(paste0('매수 ', jj,
                   ' 종목 ', KOR_ticker$종목명[j],
                   ' 가격 ', backtest_price_list[i,j], 
                   ' 수 ', wt_each_n[jj], 
                   ' 매수합계 ', wt_each_buysum[jj]))
      
      #allsumprice = sum(wt_each_sum)+jango
      print(paste0(' 잔고 ', jango, ' 계좌 평가 금액', allsumprice ))
    }
    jj=jj+1
  }
  #print(KOR_ticker$종목명[wt_j])
}

chart$SlowStochastic추세젼략 <- data.frame(matrix(unlist(mymoney),nrow=length(mymoney)))[,]


## RSI 매수 RSI+CCI 매도 전략
# make list

price_list_cci = list()

for (j in 1 : nrow(KOR_ticker)){ #j=1 day=30
  #KOR_ticker$종목명[j]
  
  price = xts(NA, order.by = Sys.Date()) # 빈 시계열 데이터 생성
  name = KOR_ticker$'종목코드'[j] # 티커 부분 선택
  #print(name) #name = '013700'
  # 오류 발생 시 이를 무시하고 다음 루프로 진행
  tryCatch({
    # url 생성
    url = paste0(
      'https://fchart.stock.naver.com/sise.nhn?symbol=',name,
      '&timeframe=day&count=900&requestType=0')
    # 데이터 다운로드
    data = GET(url)
    data_html = read_html(data, encoding = 'EUC-KR') %>%
      html_nodes("item") %>%
      html_attr("data") 
    # 데이터 나누기
    price = read_delim(data_html, delim = '|')
    # 필요한 열만 선택 후 클렌징
    # date, 시가, 고가, 저가, 종가, 거래량
    price = price[c(1,3,4,5,6)] 
    price = data.frame(price)
    colnames(price) = c('Date', 'high','low','close','volume')
    price[, 1] = ymd(price[, 1])
    rownames(price) = price[, 1]
    price[, 1] = NULL
    price = as.xts(price)
    price <- na.omit(price) # NA 제거
    price <- price[!(price$high == 0 ), ]
  }, error = function(e) {
    # 오류 발생시 해당 종목명을 출력하고 다음 루프로 이동
    warning(paste0("Error in Ticker: ", name))
  })
  #j=1
  price_list_cci[j] = list( tail(CCI(price[,c("high","low","close")],n=20),backtest_period) )
  Sys.sleep(0.1) 
}

price_list_rsi = list()

for (i in 1 : nrow(KOR_ticker)) {
  price_list_rsi[[i]] = RSI(price_list[,i],n=14)
}

price_list_rsi = do.call(cbind, price_list_rsi) %>% na.locf()
colnames(price_list_rsi) = colnames(price_list)
price_list_rsi = tail(price_list_rsi,backtest_period) 

rsi_day = 20
rsi_maesu = backtest_period+rsi_day
price_list_rsi2 = tail(price_list,rsi_maesu) 

decision_zero = rep(0, nrow(KOR_ticker)) %>% 
  setNames(KOR_ticker$'종목코드')
decision_maesumaedo = list()
decision_maesumaedo_priority = list()

for (day in 1:backtest_period) {
  
  decision = decision_zero
  priority = decision_zero
  
  for (j in 1 : nrow(KOR_ticker)){ #j=1
    
    rsi = as.numeric(price_list_rsi[day,j])
    rsi_yesterday = rsi
    if(day>1){
      rsi_yesterday = as.numeric(price_list_rsi[day-1,j])
    }
    cci = as.numeric(price_list_cci[[j]][day,'cci'])
    cci_yesterday=cci
    if(day>1){
      cci_yesterday = as.numeric(price_list_cci[[j]][day-1,'cci'])
    }
    
    ep_rsi_day = day+rsi_day
    rsi <- RSI(price_list_rsi2[day:ep_rsi_day,j],n=14)
    rsi_diff = diff(rsi)
    rsi_diff = tail(rsi_diff,1)
    rsi = tail(rsi,1)
    if(is.nan(rsi) || is.nan(rsi_diff))
    {
      rsi = 0
      rsi_diff = 0
    }
    
    # 매도 조건
    if(rsi_diff>0 
       && rsi < 63)
    {
      decision[j] = 2
    } # 매수 조건
    else if(
      (rsi > 70 || (rsi_yesterday>70 && rsi < 70))
      && (cci > 100 || (cci_yesterday>100 && cci < 100))
    )
    {
      decision[j] = -2
    } 
    
    priority[j] = rsi
    
  }
  
  decision_maesumaedo[[day]] = xts(t(decision), order.by = index(backtest_price_list[day]))
  decision_maesumaedo_priority[[day]] = xts(t(priority), order.by = index(backtest_price_list[day]))
}
decision_maesumaedo = do.call(rbind, decision_maesumaedo)
decision_maesumaedo[is.nan(decision_maesumaedo)] <- 0
decision_maesumaedo[is.na(decision_maesumaedo)] <- 0

decision_maesumaedo_priority = do.call(rbind, decision_maesumaedo_priority)
decision_maesumaedo_priority[is.nan(decision_maesumaedo_priority)] <- 0
decision_maesumaedo_priority[is.na(decision_maesumaedo_priority)] <- 0

tuja_n = 10 #매수할 최대 종목 수 지정 : 50종목
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

#### 백테스트 시작 - 고가매수저가매도
for (i in 1 : nrow(backtest_price_list)) { 
  print(paste0('평가일 :',index(backtest_price_list[i,]))) # 평가 날짜 표시
  #계좌평가 & 매도실행
  if(i!=1){ #백테스트 시작일은 평가하지 않음. 매수만 하기 때문
    wt_each_sellsum = rep(0,tuja_n) #매도할 때의 금액
    decision_del_index_maedo = which(decision_maesumaedo[i,]>=0) 
    # 매수매도 신호 순서를 숫자로 변환
    highmomentumm = order(decision_maesumaedo[i,])
    # 0이상값(매수신호,보류신호) 제거
    highmomentumm = highmomentumm[!highmomentumm %in% decision_del_index_maedo] 
    
    for(m in 1:tuja_n){ #최대 보유 종목 수 만큼
      if(wt_j[m]>0) { #종목을 보유하고 있다면
        jongmok = wt_j[m]
        if(jongmok %in% highmomentumm){ #현재 보유 종목이 매도신호 라면
          wt_each_sellsum[m]=wt_each_n[m]*backtest_price_list[i,wt_j[m]]
          print(paste0('매도 ',KOR_ticker$종목명[wt_j[m]],wt_j[m],' 총금액=', wt_each_sellsum[m],
                       ' 매도평가액=', wt_each_sellsum[m]-wt_each_buysum[m]))
          macd = as.numeric(price_list_macd[i,wt_j[m]])
          print(paste0('macd ',macd))
          wt_each_buysum[m] = 0
          wt_each_sum[m] = 0
          wt_j[m] = 0
          jango = jango + wt_each_sellsum[m] * 0.99
        }
        else{ # 매도 대상 종목이 아니라면 보유 수량 * 현재가 를 종목별 평가 금액으로 업데이트
          wt_each_sum[m]=wt_each_n[m]*backtest_price_list[i,wt_j[m]]
        }
      }
    }
    #모든 종복의 평가 금액의 합 + 잔고 를 전체 평가 금액으로 업데이트
    allsumprice = sum(wt_each_sum)+jango 
    
    print(paste0('투자금액= ',sum(wt_each_buysum),
                 ' 잔고=',jango,
                 ' 계좌 평가 금액=', allsumprice))
    
    mymoney[[i]] = allsumprice # 일자별 평가 금액 업데이트
  }
  
  #매수실행 i=50
  decision_del_index_maesu = which(decision_maesumaedo[i,]<=0) #매도,보류 신호
  #tail(decision_maesumaedo_priority,1)
  #highmomentumm = order(decision_maesumaedo[i,]) # 매수매도 신호 순서를 숫자로 변환
  highmomentumm = order(-decision_maesumaedo_priority[i,]) # 평균가 대비 현재가 상승률 높은 순
  highmomentumm = highmomentumm[!highmomentumm %in% decision_del_index_maesu] # 매도,보류 종목 삭제
  highmomentumm = highmomentumm[!highmomentumm %in% wt_j] # 이미 보유 종목은 삭제
  jj = 1 #보유종목현황 인덱스
  momentum_i = 1 #매수신호 종목 리스트 인덱스
  j=0 # 매수신호 종목 인덱스
  
  for ( column in 1 : tuja_n) { # 최대 보유 종목 수(tuja_n) 만큼 종목 매수 : 50종목
    
    if(length(highmomentumm)==0) break #매수할 종목이 없다면 중단
    
    tuja_max_price = jango / (tuja_n-sum(wt_j>0)) #한 종목당 매수 최대 금액 업데이트
    
    # wt_j는 현재 매수한 종목의 컬럼을 저장하고 있다. 0이면 아직 매수 전이라는 뜻
    # jango(현재계좌투자가능금액)가 한 종목당 매수 최대 금액(tuja_max_price)보다 커야 매수할 수 있음
    if(wt_j[jj]==0 && jango >= tuja_max_price){ 
      j = highmomentumm[momentum_i] # 매수신호 종목 
      wt_j[jj] = j # 보유종목현황에 컬럼 넘버를 지정
      
      # 현재가로 매수할 수 있는 매수수량 계산, i는 현재 백테스트 날짜
      wt_each_n[jj] = floor(tuja_max_price/backtest_price_list[i,j])
      
      # 매수 합계 계산 = 매수 수량 * 현재가
      wt_each_buysum[jj] = wt_each_n[jj] * backtest_price_list[i,j]
      
      # 잔고에서 매수금액 뺀 값을 업데이트
      jango = jango - wt_each_buysum[jj]
      
      if(momentum_i==length(highmomentumm)) break #매수신호 종목이 더이상 없다면 중단
      momentum_i = momentum_i + 1
      
      print(paste0('매수 ', jj,
                   ' 종목 ', KOR_ticker$종목명[j],
                   ' 가격 ', backtest_price_list[i,j], 
                   ' 수 ', wt_each_n[jj], 
                   ' 매수합계 ', wt_each_buysum[jj]))
      
      #allsumprice = sum(wt_each_sum)+jango
      print(paste0(' 잔고 ', jango, ' 계좌 평가 금액', allsumprice ))
    }
    jj=jj+1
  }
  #print(KOR_ticker$종목명[wt_j])
}

chart$RSI매수RSI_CCI매도전략 <- data.frame(matrix(unlist(mymoney),nrow=length(mymoney)))[,]


p <- plot_ly(chart, x = ~date, y = ~magic,
             name='매수후보유', type = 'scatter',
             mode = 'lines') %>%
  add_trace(y = ~고수저도_수정1_20종목_우선순위적용,
            name = '고수저도_우선순위적용', mode = 'lines') %>%
  add_trace(y = ~RSI필터고순위매수RSI상하컷매도,
            name = 'RSI필터고순위매수RSI상하컷매도', mode = 'lines') %>%
  add_trace(y = ~이동평균10일40일박정석킬러,
            name = '이평10일40일박정석킬러', mode = 'lines') %>%
  add_trace(y = ~볼린저밴드매매젼략,
            name = '볼린저밴드매매젼략', mode = 'lines') %>%
  add_trace(y = ~MACD추세전략,
            name = 'MACD추세전략', mode = 'lines') %>%
  add_trace(y = ~SlowStochastic젼략,
            name = 'SlowStochastic젼략', mode = 'lines')  %>%
  add_trace(y = ~SlowStochastic추세젼략,
            name = 'SlowStochastic추세젼략', mode = 'lines') %>%
  add_trace(y = ~RSI매수RSI_CCI매도전략,
            name = 'RSI매수RSI_CCI매도전략', mode = 'lines')


ggplotly(p)

