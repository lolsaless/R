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

#aggregate함수와 FUN = sum옵션을 이용하여, 날짜별 금액의 합 구하기
#by옵션은 list 요구하므로, 구매일자를 list형식으로 바꿔야한다.
cafe.daily <- aggregate(cost_cafe.df$COST, by = list(cost_cafe.df$Purchase.Date), FUN = sum)
cafe.daily

#lubridate
library(lubridate)
dt_cafe <- dmy(cafe.daily$Group.1)