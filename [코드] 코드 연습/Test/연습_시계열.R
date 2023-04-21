install.packages('forecast')
library(forecast)
plot(AirPassengers,
     xlab = 'Time(Monthly)',
     ylab = 'Number of passengers',
     main = 'Airline passengers')

airline.fit <- auto.arima(AirPassengers)
airline.fit

airline.ts <- ts(AirPassengers,
                 start = c(1949,1),
                 frequency = 4)
airline.ts

library(magrittr)
unemploy.df <- read.csv('BOK_unemployment_rate.csv')
oil.df <- read.csv('BOK_energy_oil.csv')
exchange.df <- read.csv('BOK_exchange_rate_krw_usd.csv')
#위 자료들은 시계열 자료가 아니므로 ts()함수를 이용하여 시작점과 계절주기를 지정하여 시계열 자료로 바꾼다.
unemploy.ts <- ts(unemploy.df$unemployment_rate,
                  start = 2000,
                  frequency = 1)
oil.ts <- ts(oil.df$oil,
             start = c(1994,1),
             frequency = 12)
exchange.ts <- ts(exchange.df$exchange_rate_krw_usd,
                  start = c(1980,1),
                  frequency = 4)

library(ggplot2)
ggplot(oil.df, aes(date, oil)) + geom_line()

       