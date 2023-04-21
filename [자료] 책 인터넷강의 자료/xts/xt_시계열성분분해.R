#ma()함수는 order = m 옵션을 이용하여 양방향의 이동평균을 구한다. 자료의 처음과 끝의 두 값을 잃어버린다.

library(forecast)

oil.df <- read.csv("BOK_energy_oil.csv")
oil.ts <- ts(oil.df$oil, start = c(1994,1), frequency = 12)

oil_ma_5_period <- ma(oil.ts, order = 5)
head(oil_ma_5_period)
oil.ts

#order 12, 35를 이용하면 12-MA, 35-MA의 이동평균을 구할 수 있다.

par(mfrow = c(1,2))
for(i in c(12,35)) {
  plot(oil.ts, ylab = "oil comsumption", main = paste(i, "period ma function"), col = "black")
  lines(ma(oil.ts, order = i), ylab = "oil ", col = "red")
  legend("topleft", legend = c(paste(i, "-MA")), col = "red", lty = 1)
}

#SMA 함수는 n=m의 옵션을 이용하여 한 방향의 m-SMA 이동평균을 구하고, 자료에서 처읨 4개의 값을 잃는다.
library(TTR)
oil_sma_5_period <- SMA(oil.ts, n = 5)
head(oil_sma_5_period)
tail(oil_sma_5_period)

#order 12, 35를 이용하면 12-SMA, 35-SMA의 이동평균을 구할 수 있다.

for(i in c(12, 35)) {
  plot(oil.ts, ylab = "oil comsumption", main = paste(i, "period SMA function"), col = "black")
  lines(SMA(oil.ts, n = i), ylab = "oil comsumption", col = "red")
}

oil.ts
oil.df

oil_decompose <- decompose(oil.ts)
attributes(oil_decompose)
