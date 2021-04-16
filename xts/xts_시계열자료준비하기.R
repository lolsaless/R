#규칙적인 시간간격을 지닌 시계열 자료는 ts()함수를 이용하면 날짜에 대해서 별도로 걱정할 필요 없다.

#2-1 R에 내장된 시계열 자료

is.ts(AirPassengers)
class(AirPassengers)
AirPassengers

#ts함수 옵션
airline.ts <- ts(AirPassengers)
airline.ts
?ts

# start = c(1949,1)은 1949년 1월부터 시작하게 만드는 것.
airline1.ts <- ts(AirPassengers, start = c(1949,1), frequency = 12)
airline1.ts

start(airline1.ts)
end(airline1.ts)
frequency(airline1.ts)

#csv자료 읽기
exchange_df <- read.csv('BOK_exchange_rate_krw_usd.csv')
str(exchange_df)
exchange_df

#data.frame인 자료를 ts로 변환해야한다.
is.ts(exchange_df)
class(exchange_df)
exchange.ts <- ts(exchange_df, start = c(1980,1), frequency = 4)
exchange.ts

exchange.ts <- ts(exchange_df$exchange_rate_krw_usd, start = c(1980,1), frequency = 4)
exchange.ts 