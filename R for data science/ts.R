library(forecast)
plot(AirPassengers,
     xlab = 'Time(Monthly)',
     ylab = 'Number of passengers',
     main = 'Air Line Passengers')
airline.fit <- auto.arima(AirPassengers)
airline.fit

is.ts(AirPassengers)
a <- AirPassengers

class(a)
a
b <- data.frame(a)
b
frequency(a)

c <- ts(a, 1,12,12)
c
a

airlne.ts <- ts(a, start = c(2020,1), 12)
a

airline.ts <- ts(a, start = c(1949,1), end = c(1960,12), 12)
airline.ts


start(airline.ts)
end(airline.ts)

b
ts(b)
ts(b, 1, 12, 12)
ts(b, start = c(1940,1), end = c(2060,12), 4)


a.df <- read.csv('BOK_exchange_rate_krw_usd.csv')
a.df
str(a.df)
a.df$date <- factor(a.df$date)
a.df
str(a.df)
getwd()
class(a.df)
dim(a.df)
table(a.df)
names(a.df)

a.ts <- ts(a.df$exchange_rate_krw_usd, start = c(1980,1), frequency = 4)
a.ts

a
ts(a, start = c(1949,1), frequency = 12)

ts(a, start = c(1949,1), frequency = 12)


e.df <- read.csv('BOK_macro_economic_rate.csv')
head(e.df, 3)
tail(e.df, 3)
names(e.df)

e.df
e.ts <- ts(e.df[,-1], start = c(2010,1), frequency = 12)
e.ts

f.df <- read.csv('Stock_facebook.csv')
t.df <- read.csv('Stock_twitter.csv')

head(f.df)
head(t.df)

f.ts <- ts(f.df[,7], start = c(2015,8), frequency = 12)
head(f.ts)
t.ts <- ts(t.df[,7], start = c(2015,8), frequency = 12)
head(t.ts)
library(quantmod)

getSymbols('FB', src = 'yahoo', from = as.Date('2015-08-01'),
           to = as.Date('2016-08-31'))
head(FB)
getSymbols('TWTR', src = 'yahoo', from = as.Date('2015-08-01'),
           to = as.Date('2016-08-31'))



u.df <- read.csv('BOK_unemployment_rate.csv')
o.df <- read.csv('BOK_energy_oil.csv')
ex.df <- read.csv('BOK_exchange_rate_krw_usd.csv')

u.ts <- ts(u.df$unemployment_rate, start = 2000, frequency = 1)
u.ts
u.df

o.ts <- ts(o.df$oil, start = c(1994,1), frequency = 12)
ex.ts <- ts(ex.df$exchange_rate_krw_usd, start = c(1980,1), frequency = 4)
plot(u.ts)
plot(o.ts)
plot(ex.ts)

par(mfrow = c(2,2))
plot(FB$FB.Adjusted, xlab = 'time(daily)', ylab = 'price', main = 'FB')
plot(o.ts, xlab = 'time(monthly)', ylab = 'petrolem consumption', main = 'Korea')

plot(e.ts)

two.ts <- cbind(f.ts, t.ts)
class(two.ts)
f.ts
t.ts
two.ts
a <- rbind(f.ts, t.ts)
a

two.ts[1:5,]
plot(two.ts)

plot(two.ts, plot.type = 'single', main = 'Monthly closing prices on FB and TWTR',
     ylab = 'Adjusted close price',
     col = c('blue', 'red'),
     lty = c(1,2))

ts.plot(f.ts, t.ts,
        lty = c(1,2))
legend('right', legend = c('FB', 'TWTR'), col=c('blue', 'red'), lty = c(1,2))

par(mar=c(5,4,4,10)+.10)


chartSeries(FB, theme = 'white', subset = '2015::2016-08')
?chartSeries


a.q <- aggregate(AirPassengers, nfrequency = 4, FUN = sum)
a.q
ts(AirPassengers, start = 1949, frequency = 4)
