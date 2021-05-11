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
class(exchange_df)
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

facebook.df <- read.csv("Stock_facebook.csv")
twitter.df <- read.csv("Stock_twitter.csv")

str(faceboodk.df)
str(twitter.df)

faceboodk.df

faceboodk.ts <- ts(faceboodk.df$Adj.Close, start = c(2015,8), frequency = 12)
twitter.ts <- ts(twitter.df$Adj.Close, start = c(2015,8), frequency = 12)

library(quantmod)

getSymbols("FB", src = "yahoo", from = as.Date('2015/08/01'), to = as.Date('2016/08/31'))
str(FB)

getSymbols("TWTR", src = "yahoo", from = as.Date('2015/08/01'), to = as.Date('2016/08/31'))


#4 시계열 그리기
#4-1 한 파일에 1개의 시계열

unemploy.df <- read.csv("BOK_unemployment_rate.csv")
oil.df <- read.csv("BOK_energy_oil.csv")
exchange.df <- read.csv("BOK_exchange_rate_krw_usd.csv")

unemploy.ts <- ts(unemploy.df$unemployment_rate, start = 2000, frequency = 1)
unemploy.ts
oil.ts <- ts(oil.df$oil, start = c(1994,1), frequency = 12)
exchange.ts <- ts(exchange.df$exchange_rate_krw_usd, start = c(1980,1), frequency = 4)

par(mfrow = c(2,2))
plot(FB$FB.Adjusted, xlab = "Time(Daily)", ylab = "Adjusted Price", main = "Facebook")
plot(oil.ts, xlab = "Time(Monthly)", ylab = "Petrolem consumption", main = "Korean energy Petrolem consumption")
plot(exchange.ts, xlab = "Time(Quarterly)", ylab = "Exchange rate", main = "Exchange rate KRW per USD")
plot(unemploy.ts, xlab = "Time(Yearly)", ylab ="Unemployment rate", main = "Korean unemployment rate")

#4-2 한 파일에 2개의 시계열
plot(economic.ts, main = "Two tiem series in one file")

par(mfrow = c(1,2))
plot(economic.ts[,1], ylab = "Rate %", main = "Monthly employment rate", col = "blue", lwd = 2) 
plot(economic.ts[,2], ylab = "bond 3 years(year %)", main = "Treasuray bond 3 years", col = "red", lwd = 2) 
economic.ts[,1]


#4-3 두 시계열 붙이기
two.ts <- cbind(faceboodk.ts, twitter.ts)
head(two.ts)
class(two.ts)

par(mfrow = c(1,1))
plot(two.ts, ylab = '', main = "Adjusted close", col = 'blue', lwd = 2)

#페이스북과 트위터 주가 한 패널에 그리기 plot.type = multiple or single
plot(two.ts, plot.type = "single", main = "Monthly closing prices on FB and TWTR",
     ylab = "Adjusted close price",
     col = c("blue", "red"),
     lty =1:2)
plot(two.ts, plot.type = "multiple", main = "Monthly closing prices on FB and TWTR",
     ylab = "Adjusted close price",
     col = c("blue", "red"),
     lty = 1:2,
     lwd = 2)

legend("right", legend = c("FB", "TWTR"), col = c("blue", "red"), lty = 3:2)

#ts.plot을 이용하면 두 시계열 자료를 하나의 object로 합치지 않고도 한 패널에 그려넣을 수 있다.
ts.plot(faceboodk.ts, twitter.ts, main = "Monthly closing prices on FB and TWTR",
        ylab = "Adjusted close price",
        col = c("blue", "red"),
        lty = 1:2)

plot(faceboodk.ts,
     col = "blue",
     lwd = 2,
     ylab = "FB Adjusted close",
     main = "Monthly closing price")

#그림 덮어쓰기 가능하게 해주는 함수
par(new = TRUE)

#덮어쓰기(x,y축 요소 모두 제거)
plot(twitter.ts,
     col = 'red',
     lwd = 2,
     xaxt = "n",
     yaxt = "n",
     ylab = "",
     xlab = "")

axis(4)
axis(1)
axis(2)
axis(3)
axis(4)
mtext("TWTR Adjusted colse",
      side = 4,
      line = 3)

#quantmod 이용하기

chart_Series(TWTR, subset = "2016-07-01::2016-08-01")
chartSeries(TWTR, subset = "2016-07-01::2016-08-01")


#5 시계열자료 계절주기 변환

air_quarterly <- aggregate(AirPassengers, nfrequency = 4, FUN = sum)
air_quarterly
AirPassengers

###시계열자료를 데이터프레임으로 전환하는 방법 찾기###

par(mfrow = c(1,2))
plot(AirPassengers,
     xlab = "Time(Monthly)",
     ylab = "Number of passengers",
     main = "Airline passengers")
plot(air_quarterly,
     xlab = "Time(Quarterly)",
     ylab = "Number of passengers",
     main = "Sum aggregation")

air_quarterly_mean <- aggregate(AirPassengers, nfrequency = 4, FUN = mean)
air_quarterly_mean

par(mfrow = c(1,2))
plot(AirPassengers,
     xlab = "Time(Monthly)",
     ylab = "Number of passengers",
     main = "Airline passengers")
plot(air_quarterly_mean,
     xlab = "Time(Quarterly)",
     ylab = "Number of passengers",
     main = "Mean' aggregation")

air_yearly <- aggregate(AirPassengers, nfrequency = 1, FUN = sum)
air_yearly
a <- data.frame(air_yearly)
day <- seq(as.Date("1949/1/1"), as.Date("1960/1/1"), by = "year")
day
aa <- data.frame(a, day)
aa


