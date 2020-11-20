library(stringr)
library(dplyr)

KOR_value = read.csv('data/KOR_value.csv', row.names = 1,
                     stringsAsFactors = FALSE)
KOR_fs = readRDS('data/KOR_fs.Rds')
KOR_ticker = read.csv('data/KOR_ticker.csv', row.names = 1,
                      stringsAsFactors = FALSE) 

data_pbr = KOR_value['PBR']

if ( lubridate::month(Sys.Date()) %in% c(1,2,3,4) ) {
  num_col = ncol(KOR_fs[[1]]) - 1
} else {
  num_col = ncol(KOR_fs[[1]]) 
}

data_gpa =
  (KOR_fs$'매출총이익' / KOR_fs$'자산')[num_col] %>%
  setNames('GPA')

cbind(data_pbr, -data_gpa) %>%
  cor(method = 'spearman', use = 'complete.obs') %>% round(4)

cbind(data_pbr, data_gpa) %>%
  mutate(quantile_pbr = ntile(data_pbr, 5)) %>%
  filter(!is.na(quantile_pbr)) %>%
  group_by(quantile_pbr) %>%
  summarise(mean_gpa = mean(GPA, na.rm = TRUE)) %>%
  ggplot(aes(x = quantile_pbr, y = mean_gpa)) +
  geom_col() +
  xlab('PBR') + ylab('GPA')

library(stringr)
library(dplyr)

KOR_value = read.csv('data/KOR_value.csv', row.names = 1,
                     stringsAsFactors = FALSE)
KOR_fs = readRDS('data/KOR_fs.Rds')
KOR_ticker = read.csv('data/KOR_ticker.csv', row.names = 1,
                      stringsAsFactors = FALSE) 
KOR_ticker$'종목코드' =
  str_pad(KOR_ticker$'종목코드', 6, 'left', 0)

if ( lubridate::month(Sys.Date()) %in% c(1,2,3,4) ) {
  num_col = ncol(KOR_fs[[1]]) - 1
} else {
  num_col = ncol(KOR_fs[[1]]) 
}

# 분자
magic_ebit = (KOR_fs$'지배주주순이익' + KOR_fs$'법인세비용' +
                KOR_fs$'이자비용')[num_col]

# 분모
magic_cap = KOR_value$PER * KOR_fs$'지배주주순이익'[num_col]
magic_debt = KOR_fs$'부채'[num_col]
magic_excess_cash_1 = KOR_fs$'유동부채' - KOR_fs$'유동자산' +
  KOR_fs$'현금및현금성자산'
magic_excess_cash_1[magic_excess_cash_1 < 0] = 0
magic_excess_cash_2 =
  (KOR_fs$'현금및현금성자산' - magic_excess_cash_1)[num_col]

magic_ev = magic_cap + magic_debt - magic_excess_cash_2

# 이익수익률
magic_ey = magic_ebit / magic_ev

magic_ic = ((KOR_fs$'유동자산' - KOR_fs$'유동부채') +
              (KOR_fs$'비유동자산' - KOR_fs$'감가상각비'))[num_col]
magic_roc = magic_ebit / magic_ic

invest_magic = rank(rank(-magic_ey) + rank(-magic_roc)) <= 30

KOR_ticker[invest_magic, ] %>%
  select(`종목코드`, `종목명`) %>%
  mutate(`이익수익률` = round(magic_ey[invest_magic, ], 4),
         `투하자본수익률` = round(magic_roc[invest_magic, ], 4))