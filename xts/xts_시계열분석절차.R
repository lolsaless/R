library(dplyr)
oil.ts <- read.csv("BOK_energy_oil.csv") %>% ts(.$oil, start = c(1994,1), frequency = 12)
oil.df <- read.csv("BOK_energy_oil.csv")
oil.ts <- ts(oil.df$oil, start = c(1994,1), frequency = 12)
oil.ts

oil_sub_before.ts <- window(oil.ts, end = c(2004,12))
oil_sub_before.ts

oil_sub_after.ts <- window(oil.ts, start = c(2005,1))
oil_sub_after.ts

oil_log.ts <- log(oil.ts)
oil_log.ts
par(mfrow = c(1,2))
plot(oil.ts,
     xlab = "Time(Monthly)",
     ylab = "Petrolem consumption",
     main = "Raw data")
plot(oil_log.ts,
     xlab = "Time(Monthly)",
     ylab = "Petrolem consumption",
     main = "Log data")
#raw data 와 log data의 차이를 모르겠음

#시계열차분
#1차 차분
oil_dif1.ts <- diff(oil.ts)
par(mfrow = c(1,1))
plot(oil_dif1.ts,
     xlab = "Time(Monthly)",
     ylab = "Petrolem consumption",
     main = "First order differenced")
#자료가 1차 차분된 후 추세가 사라지고 0을 중심으로 퍼져있다.
#계절차분
oil_dif12.ts <- diff(oil.ts, lag = 12)
plot(oil_dif12.ts,
     xlab = "Time(Monthly)",
     ylab = "Petrolem consumption",
     main = "Seasonal Differenced")
#1차차분 + 계절차분
oil_dif1_dif12.ts <- diff(oil_dif1.ts, lag = 12)
plot(oil_dif1_dif12.ts)

library(forecast)
ndiffs(oil.ts)
ndiffs(oil_dif1.ts)
nsdiffs(oil.ts)
nsdiffs(oil_dif12.ts)

#단위근검정
econonmic.df <- read.csv("~/R/code/data_xts/BOK_macro_economic_rate.csv")
econonmic.ts <- ts(econonmic.df[,-1], start = c(2010,1), frequency = 12)
bond_dif.ts <- diff(econonmic.ts[,2])
plot(bond_dif.ts)

#pp.test phillips-perron 단위근검정
PP.test(econonmic.ts[,2])
#p-value 0.3273으로 유의수준 a=0.05에서 귀무가설을 기각할 수 없다.
#따라서 1차 차분이 필요하다.

PP.test(bond_dif.ts)
#더 이상 차분이 필요 없다.

library(tseries)
adf.test(econonmic.ts[,2], k=3)
?adf.test


samsung.df <- read.csv("005930.KS.csv")

head(samsung.df)
str(samsung.df)
