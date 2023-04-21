#POS구매자료를 일별 자료로 변환
library(dplyr)
cafe.df <- read.csv('POS_cafe_purchase.csv')
head(cafe.df)
str(cafe.df)
dim(cafe.df)

cost_cafe.df <- cafe.df %>% select(Purchase.Date, COST)
cost_cafe.df

cafe_daily <- aggregate(cost_cafe.df$COST,
                        by = list(cost_cafe.df$Purchase.Date), FUN = sum)
cafe_daily

library(lubridate)
df_cafe <- dmy(cafe_daily$Group.1)
df_cafe

library(zoo)
cafe.zoo <- zoo(cafe_daily$x, order.by = df_cafe)
head(cafe.zoo)
plot(cafe.zoo)

#일별 자료를 월별 자료로 변환
won_per_dollar.df <- read.csv('BOK_won_per_dollar.csv')
td2 <- as.Date(won_per_dollar.df$date, format = '%Y/%m/%d')
won_per_dollar.zoo <- zoo(won_per_dollar.df$won_per_dollar, order.by = td2)
head(won_per_dollar.zoo)
won_per_dollar.zoo
won_per_dollar.df

library(xts)
month.end <- endpoints(won_per_dollar.zoo, on='months', k=1)
month.end
won_per_dollar.zoo <- period.apply(won_per_dollar.zoo,
                                   INDEX = month.end,
                                   FUN = last)
won_per_dollar.zoo
