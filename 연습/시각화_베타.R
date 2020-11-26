library(quantmod)
library(PerformanceAnalytics)
library(magrittr)

symbols <- c('102110.KS', '039490.KS')
getSymbols(symbols)

prices <- do.call(cbind,
                  lapply(symbols, function(x)Cl(get(x))))

ret <- Return.calculate(prices)
ret <- ret['2016-01::2018-12']

rm <- ret[,1]
ri <- ret[,2]

rm <- as.numeric(rm)
ri <- as.numeric(ri)

colnames(ret) <- c('rm', 'ri')


library(ggplot2)

ggplot(ret, aes(rm, ri)) +
  geom_point() +
  scale_x_continuous('KOSPI 200') +
  scale_y_continuous('Individual Stock') +
  coord_cartesian(xlim = c(-0.02, 0.02), ylim = c(-0.02, 0.02)) +
  geom_abline(lty=2) +
  geom_smooth(method='lm', se=F, color='red')

