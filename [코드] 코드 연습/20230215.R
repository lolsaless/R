library(tidyverse)

fuel <- data.frame(fl = c("c", "d", "e", "p", "r"),
                   price_fl = c(2.35, 2.38, 2.11, 2.76, 2.22),
                   stringsAsFactors = FALSE)
fuel
head(mpg)
mpg2 <- mpg

mpg2 <- mpg2 %>% left_join(., fuel, by = "fl")
mpg2
str(mpg2)
mpg2 %>% select(model, fl, price_fl) %>% head(5)

#분석도전
midwest2 <- midwest
midwest2 <- midwest2 %>% mutate(ratio = (poptotal - popadults)/poptotal * 100,
                                .before = 1)

midwest2 %>% arrange(desc(ratio)) %>% head(5 )
midwest2 %>% select(ratio, county) %>% 
  arrange(desc(ratio)) %>% head(5)

midwest3 <- midwest2 %>% mutate(grade= ifelse(ratio >= 40, "large",
                                              ifelse(ratio >= 30, "middle",
                                                     "small")))
midwest3 %>% group_by(grade) %>% 
  summarise(cnt = n())

midwest4 <- NA
midwest4 <- midwest3 %>% mutate(asianRatio = (popasian/poptotal) * 100)

midwest4 %>% select(state, county, asianRatio) %>% 
  arrange(asianRatio) %>% head(10)


