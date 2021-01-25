library(httr)
library(rvest)
library(stringr)
library(xts)
library(lubridate)
library(readr)
library(timetk)

KOR_ticker = read.csv('data/KOR_ticker.csv', row.names = 1)
print(KOR_ticker$'종목코드'[1])
KOR_ticker$'종목코드' =
  str_pad(KOR_ticker$'종목코드', 6, side = c('left'), pad = '0')

ifelse(dir.exists('data/KOR_price'), FALSE,
       dir.create('data/KOR_price'))

for(i in 1 : nrow(KOR_ticker) ) {
  
  price = xts(NA, order.by = Sys.Date()) # 빈 시계열 데이터 생성
  name = KOR_ticker$'종목코드'[i] # 티커 부분 선택
  
  from = (Sys.Date() - years(3)) %>% str_remove_all('-') # 시작일
  to = Sys.Date() %>% str_remove_all('-') # 종료일
  
  # 오류 발생 시 이를 무시하고 다음 루프로 진행
  tryCatch({
    # url 생성
    url = paste0('https://fchart.stock.naver.com/siseJson.nhn?symbol=', name,
                 '&requestType=1&startTime=', from, '&endTime=', to, '&timeframe=day')
    
    # 이 후 과정은 위와 동일함
    # 데이터 다운로드
    data = GET(url)
    data_html = data %>% read_html %>%
      html_text() %>%
      read_csv()
    
    # 필요한 열만 선택 후 클렌징
    price = data_html[c(1, 5)]
    colnames(price) = (c('Date', 'Price'))
    price = na.omit(price)
    price$Date = parse_number(price$Date)
    price$Date = ymd(price$Date)
    price = tk_xts(price, date_var = Date)
    
  }, error = function(e) {
    
    # 오류 발생시 해당 종목명을 출력하고 다음 루프로 이동
    warning(paste0("Error in Ticker: ", name))
  })
  
  # 다운로드 받은 파일을 생성한 폴더 내 csv 파일로 저장
  write.csv(data.frame(price),
            paste0('data/KOR_price/', name, '_price.csv'))
  
  # 타임슬립 적용
  Sys.sleep(2)
}
