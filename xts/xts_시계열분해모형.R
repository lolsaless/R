library(dplyr)
oil.ts <- read.csv("BOK_energy_oil.csv") %>% ts(.$oil, start = c(1994,1), frequency = 12)
oil.df <- read.csv("BOK_energy_oil.csv")
oil.ts <- ts(oil.df$oil, start = c(1994,1), frequency = 12)
oil.ts

oil_decompose <- decompose(oil.ts)
attributes(oil_decompose)

plot(oil_decompose)

#stl함수를 이용한 시계열분해모형
#stl함수는 이상값에 대해 민감하지 않고, t.window, s.window 옵션을 이용해서 추세와 계절성의 변화를 사용자가 조절할 수 있다.
#이 두 값이 작을수록 변화를 빨리 감지하고, 클수록 변동에 민감하지 않다.
#stl의 속성에서 $name을 살펴보면 time.series변수가 있는데 oil_stl$time.series를 살펴보면 계절, 추세, 불규칙항을 보여준다.

oil_stl_w10 <- stl(oil.ts, s.window = "periodic", t.window = 10)
attributes(oil_stl_w10)
head(oil_stl_w10$time.series)
plot(oil_stl_w10, main = "Decomposition using stl() function with t.window=10")

oil_stl_w100 <- stl(oil.ts, s.window = "periodic", t.window = 100)
plot(oil_stl_w100)

library(forecast)

#3-1예측
oil_stl_forecast_w10 <- forecast(oil_stl_w10, method = "naive")
oil_stl_forecast_w100 <- forecast(oil_stl_w100, method = "naive")

names(oil_stl_forecast_w10)
oil_stl_forecast_w10$method
oil_stl_forecast_w10$model
oil_stl_forecast_w100$method
oil_stl_forecast_w100$model

#seasadj()함수를 이용한 계절조정된 시계열자료
oil_seasadj <- seasadj(oil_stl_w10)
head(oil_seasadj)
#oil_seasadj_w10은 계절조정된 값으로, 원시계열에서 계절성분값을 뺸 것을 의미한다.

par(mfrow = c(1,2))
plot(oil.ts, main = "Actual vs sesonal adjusted")
lines(oil_seasadj, col = "red")
legend("bottomright", legend = "seasonal adjusted", col = c("red"), lty = 1)

#4-1예측
oil_naive = naive(oil_seasadj)
#naive모형의 예측값은 자료의 평균이다. 따라서 예측값이 일직선으로 나타난다.
par(mfrow = c(1,1))
plot(oil_naive, ylab = "oil.ts", main = "seasonally adjusted naive() forecast")
