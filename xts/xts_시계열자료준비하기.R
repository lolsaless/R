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

exchange.ts <- ts(exchange_df$exchange_rate_krw_usd, start = c(1980, 1), frequency = 12)
exchange.ts 

oil_user_enter.df <- read.csv("Oil_User_Enter.csv")
head(oil_user_enter.df)
str(oil_user_enter.df)
tail(oil_user_enter.df)
dim(oil_user_enter.df)
class(oil_user_enter.df)

head(oil_user_enter.df, 3)

oil_user_enter.ts <- ts(oil_user_enter.df$oil, start = c(1994,1), frequency = 12)
oil_user_enter.ts

oil_user_enter.ts

#연속된 시간 변수 만드는 함수 기억하기.
date <- seq(as.Date("1994/1/1"), by = 'month', length.out = 12)
?seq
seq(1, 9, by = 2)

#seq&as.date 함수연습
seq_day <- seq(as.Date("2020/5/5"), as.Date("2021/5/5"), by = 'day')
seq_day
seq_day <- seq(as.Date("2020/5/1"), by = 'month', length.out = 12)
seq_day

seq_day_oil.df <- data.frame(seq_day, oil_user_enter.ts)
seq_day_oil.df
seq_day_oil.ts <- ts(seq_day_oil.df$oil_user_enter.ts, start = c(2020,5), frequency = 12)
seq_day_oil.ts

#이렇게 바로 ts로 변환하면 엑셀에서 처럼 날짜->숫자형으로 나타난다. 해결방법 강구할 것
ts(seq_day, start = c(2020,5), frequency = 12)
a <- data.frame(date, oil_user_enter.ts)
a
str(a)
b <- ts(a$oil_user_enter.ts, start = c(1994,1), frequency = 12)
b

#경제시계열 자료, bond_3_year = 국고채 3년 수익률
economic.df <- read.csv("BOK_macro_economic_rate.csv")
economic.df

str(economic.df)
economic.df[-2]

economic.ts <- ts(economic.df[-1], start = c(2010,1), frequency = 12)
economic.ts[,1]
str(economic.ts)
#ts에서는 $열이름 으로 선택할 수 없다.

employment.ts <- ts(economic.df$employment_rate, start = c(2010,1), frequency = 12)
employment.ts
economic.ts[,1]
#위 두 ts는 같은 내용을 담고 있다.

#3-2 주가 시계열 자료