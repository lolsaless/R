economic.df <- read.csv("data_xts/BOK_macro_economic_rate.csv")
economic.ts <- ts(economic.df[-1], start = c(2010,1), frequency = 12)
economic.ts

plot(economic.ts[,2], col = "red", lwd = 5, ylab = "bond 3 years(Year%)", main = "Treasuray bond 3 years")
#국고채 3년 수익률 시계열 자료는 감소추세를 지닌 것으로 확인되었다.
#또한 단위근 검정을 통해 그 추세가 확률적 추세임을 알 수 있었다.
#자기상관함수를 이용하여 추세가 있는지를 알아보자
#표본 자기상관함수는 이론적인 자기상관함수의 추정값이며 acf함수에서는 이 추정값과 표본오차를 제공한다.

acf(economic.ts[,2], main = "ACF of 3 year bond using acf{stats}")
bond_dif.ts <- diff(economic.ts[,2])
acf(bond_dif.ts, main = "ACF of differenced 3 year bond using acf{stats}")

Acf(economic.ts[,2])
Acf(bond_dif.ts)

Pacf(economic.ts[,2])
Pacf(bond_dif.ts)

bond_ar_fit <- ar(bond_dif.ts, method = "ols", order.max = 5)
bond_ar_fit

bond_ar_fit$asy.se.coef
bond_ar_fit$aic
$