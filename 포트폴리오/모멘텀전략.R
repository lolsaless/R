library(stringr)
library(xts)
library(PerformanceAnalytics)
library(magrittr)
library(dplyr)

KOR_price = read.csv('data/KOR_price.csv', row.names = 1,
                     stringsAsFactors = FALSE) %>% as.xts()
KOR_ticker = read.csv('data/KOR_ticker.csv', row.names = 1,
                      stringsAsFactors = FALSE) 
KOR_ticker$'종목코드' =
  str_pad(KOR_ticker$'종목코드', 6, 'left', 0)

ret = Return.calculate(KOR_price) %>% xts::last(252) 
ret_12m = ret %>% sapply(., function(x) {
  prod(1+x) - 1
})

ret_12m[rank(-ret_12m) <= 30]

invest_mom = rank(-ret_12m) <= 30
KOR_ticker[invest_mom, ] %>%
  select(`종목코드`, `종목명`) %>%
  mutate(`수익률` = round(ret_12m[invest_mom], 4))





ret = Return.calculate(KOR_price) %>% xts::last(252) 
ret_12m = ret %>% sapply(., function(x) {
  prod(1+x) - 1
})
std_12m = ret %>% apply(., 2, sd) %>% multiply_by(sqrt(252))
sharpe_12m = ret_12m / std_12m


invest_mom_sharpe = rank(-sharpe_12m) <= 30
KOR_ticker[invest_mom_sharpe, ] %>%
  select(`종목코드`, `종목명`) %>%
  mutate(`수익률` = round(ret_12m[invest_mom_sharpe], 2),
         `변동성` = round(std_12m[invest_mom_sharpe], 2),
         `위험조정 수익률` =
           round(sharpe_12m[invest_mom_sharpe], 2)) %>%
  as_tibble() %>%
  print(n = Inf)



intersect(KOR_ticker[invest_mom, '종목명'],
          KOR_ticker[invest_mom_sharpe, '종목명'])


library(xts)
library(tidyr)
library(ggplot2)

KOR_price[, invest_mom_sharpe] %>%
  fortify.zoo() %>%
  gather(ticker, price, -Index) %>%
  ggplot(aes(x = Index, y = price)) +
  geom_line() +
  facet_wrap(. ~ ticker, scales = 'free') +
  xlab(NULL) +
  ylab(NULL) +
  theme(axis.text.x=element_blank(),
        axis.text.y=element_blank())