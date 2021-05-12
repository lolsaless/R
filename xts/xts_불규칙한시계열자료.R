#1 zoo()함수로 시계열자료 만들기
#ts함수는 불규칙한 시계열 자료에 제한이 있으나, zoo는 이를 다룰 수 있다.

facebook.df <- read.csv("Stock_facebook.csv")
str(facebook.df)
td2 <- as.Date(facebook.df$Date, format = "%m/%d/%y")
td2
library(zoo)

facebook.zoo <- zoo(facebook.df$Adj.Close, order.by = td2)
facebook.zoo
str(facebook.zoo)

#날짜추출
index(facebook.zoo)
#데이터추출
coredata(facebook.zoo)

#POS구매자료를 일별 자료료 변환
cafe.df <- read.csv("POS_cafe_purchase.csv")
cafe.df
str(cafe.df)
dim(cafe.df)

library(dplyr)

cost_cafe.df <- select(cafe.df, c(Purchase.Date, COST))
cost_cafe.df
str(cost_cafe.df)

#aggregate함수와 FUN = sum옵션을 이용하여, 날짜별 금액의 합 구하기
#by옵션은 list 요구하므로, 구매일자를 list형식으로 바꿔야한다.
cafe.daily <- aggregate(cost_cafe.df$COST, by = list(cost_cafe.df$Purchase.Date), FUN = sum)
cafe.daily
str(cafe.daily)

#name함수를 이용하여 열 이름바꾸기
names(cafe.daily) = c('Date', "sum_cost")
cafe.daily

#lubridate를 이용하여 Date열의 chacter를 Date포맷으로 변경하기.
library(lubridate)
dt_cafe <- dmy(cafe.daily$Date)

str(dt_cafe)

#뒤죽박죽으로 되어있던 데이터를 일자별 순서대로 사용한 비용을 합산하여 정열
cafe.zoo <- zoo(cafe.daily$sum_cost, order.by = dt_cafe)
cafe.zoo


plot(cafe.zoo,
     xlab = "Time(Daily)",
     ylab = "Aggreagted pirce",
     main = "Daily Aggregated POS cafe pirce")

#일별 자료를 월별 자료로 변환
#won_per_dollar.df는 규칙적 시차를 가지지 않는다.

won_per_dollar.df <- read.csv("BOK_won_per_dollar.csv")
str(won_per_dollar.df)

td2 <- as.Date(won_per_dollar.df$date, format = "%Y/%m/%d")
td2
str(td2)
summary(td2)

won_per_dollar.zoo <- zoo(won_per_dollar.df$won_per_dollar, order.by = td2)
head(won_per_dollar.zoo)
won_per_dollar.zoo
library(xts)
#xts라이브러리 endpoint 함수와 period.apply함수는 자료의 주기를 바꿀 때 사용
#일별 자료를 월별 자료로 변환할 때 endpoints함수를 이용하여 먼저 월말의 날짜를 만들어
#month.end 변수로 저장하고, period.apply명령어로 월말 자료를 월별 자료로 만든다.

#매달의 마지막 포인트(합산 0부터 시작해서 1월은 24, + 2월 23 더해서 47)
month.end <- endpoints(won_per_dollar.zoo, on = "months", k=1)
month.end

won_per_dollar_monthly.zoo <- period.apply(won_per_dollar.zoo,
                                           INDEX = month.end,
                                           FUN = last)
won_per_dollar_monthly.zoo
tail(won_per_dollar.df)

head(won_per_dollar_monthly.zoo, 5)


quarter.end <- endpoints(won_per_dollar.zoo, on = 'quarters', k=1)
won_per_dollar_quaterly <- period.apply(won_per_dollar.zoo,
                                        INDEX = quarter.end,
                                        FUN = last)
won_per_dollar_quaterly

year.end <- endpoints(won_per_dollar.zoo, on = 'years', k = 1)
year.end

won_per_dollar_year.zoo <- period.apply(won_per_dollar.zoo,
                                        INDEX = year.end,
                                        FUN = last)
won_per_dollar_year.zoo

#여기서 k는 묶는 개수를 지정하는 것으로, months k=12로 하면 1년으로 동일한 효과 나온다.

par(mfrow = c(2,2))
plot(won_per_dollar.zoo,
     main = "Daily")
plot(won_per_dollar_monthly.zoo,
     main = "Monthly")
plot(won_per_dollar_quaterly,
     main = "Quarterly")
plot(won_per_dollar_year.zoo,
     main = "Yearly")

#주기가 커지면서 자료의 세부적 움직임이 줄고 흐름이 완만해진다.
