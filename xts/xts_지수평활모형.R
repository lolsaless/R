library(forecast)
oil.df <- read.csv("data_xts/BOK_energy_oil.csv")
oil.ts <- ts(oil.df$oil, start = c(1994, 1), frequency = 12)
oil_ses_fit1 <- ses(oil.ts, alpha = 0.2, initial = "simple", h = 6)
oil_ses_fit2 <- ses(oil.ts, h = 6)
names(oil_ses_fit1)
oil_ses_fit1$model

#oil_ses_fit$model에서 알파는 0.2로 고정시킨 값이고
#시그마는 838.6667이다. oil_ses_fit1은 고정된 모형이므로 AIC, AICc  값을 구할 수 없다.
#oil_ses_fit2는 알파를 정하지 않았기에 ses()함수가 알파를 추정할 것이다.

oil_ses_fit2$model

round(rbind(accuracy(oil_ses_fit1), accuracy(oil_ses_fit2)), digit = 3)
#두 모형을 MAPE값으로 비교한 결과 fit2모형이 더 좋은 결과를 보여준다.

oil_ses_fit1$mean

par(mfrow = c(1,1))
plot(oil_ses_fit1, ylab = "oil", xlab = "year", main = "simple exponential smoothing")
lines(fitted(oil_ses_fit1), col = "red")
lines(fitted(oil_ses_fit2), col = "blue")
lines(oil_ses_fit1$mean, col = "red", type = "o")
lines(oil_ses_fit2$mean, col = "blue", type = "o")
legend("bottomright", lty = 1, col = c(1, "red", "blue"), c("data", expression(alpha == 0.2),
                                                            expression(alpha == 0.845)), pch = 1)


#선형추세평활모형
#이 모형은 선형적 추세를 지닌 시계열자료에 적합하다.
#평활식은 평균과 추세에 가중치를 부여하는 것이다.
oil_holt_fit1 <- holt(oil.ts)
oil_holt_fit2 <- holt(oil.ts, damped = TRUE)
names(oil_holt_fit1)
oil_holt_fit1$method
oil_holt_fit2$method

round(rbind(accuracy(oil_holt_fit1), accuracy(oil_holt_fit2)), digit = 3)
#구간내 예측값과 6개월 앞의 예측값을 구하자.
tail(oil_holt_fit1$mean, n = 6)

par(mfrow = c(1,1))
plot(oil_holt_fit1, ylab = "oil", xlab = "year", type = "o")
lines(oil_holt_fit1$mean, col = "red", type = "o")
lines(oil_holt_fit2$mean, col = "blue", type = "o")
legend("topleft", lty = 1, col = c(1,"red","blue"), c("data", expression(fit1:linter),
                                                      expression(fit2:damped)), pch = 1)
