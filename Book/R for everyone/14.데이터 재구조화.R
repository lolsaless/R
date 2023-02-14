#cbind, rbind

sport <- c("Hockey", "Baseball", "Football")
league <- c("NHL", "MLB", "NFL")
trophy <- c("stanley cup", "Commissioner's Trophy", "Vince lombardi Trophy")
trophies <- cbind(sport, league, trophy)

trophies2 <- data.frame(sport = c("Basketball", "Golf"),
                        league = c("NBA", "PGA"),
                        trophy = c("Larry O'Brien Championship Trophy",
                                   "Wanamaker Trophy"),
                        stringsAsFactors = FALSE)
trophies
trophies2

trophies3 <- rbind(trophies, trophies2)
trophies3

library(tidyverse)
theFiles <- dir("US_Foreign_Aid/", pattern = "\\.csv")
theFiles[1]

theFiles %>% str_sub(.[1], start = 12, end = 18)
theFiles %>% .[1]

cnt = 0
for(i in theFiles) {
  nameToUse <- str_sub(string = i, start = 12, end = 18)
  
  temp <- read.table(file = file.path("US_Foreign_Aid", i),
                     header = TRUE, sep = ",", stringsAsFactors = FALSE)
  assign(x = nameToUse, value = temp)
  cnt <-  cnt + 1
  msg <- paste0(cnt,"번째 파일", i, "을 불러들였습니다.")
  cat(msg, "\n")
  Sys.sleep(2)
}

