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

#merge 함수
Aid90s00s <- merge(x = Aid_90s, y = Aid_00s,
                   by.x = c("Country.Name", "Program.Name"),
                   by.y = c("Country.Name", "Program.Name"))
head(Aid90s00s)

#plyr join 함수
library(tidyverse)
library(plyr)
Aid90s00sJoin <- join(x = Aid_90s, y = Aid_00s,
                      by = c("Country.Name", "Program.Name"))

head(Aid90s00sJoin)

#먼저 데이터 프레임의 이름을 확인한다.
frameNames <- str_sub(string = theFiles, start = 12, end = 18)

#빈 리스트 생성
frameList <- vector("list", length(frameNames))
frameList
names(frameList) <- frameNames


for (i in frameNames) {
  frameList[[i]] <- eval(parse(text = i))
}

str(frameList[[1]])
head(frameList[[1]])

for (i in 1:8) {
  frameList[[i]] <- i
}
frameList

?parse
libs <- c("a", "b", "c")
libs[1]

library(plyr)

allAid <- Reduce(function(...) {
  join(..., by = c("Country.Name", "Program.Name"))},
  frameList)

#14.3 reshape2 패키지
head(Aid_00s)
library(reshape2)
melt00 <- melt(Aid_00s, id.vars = c("Country.Name", "Program.Name"),
               variable.name = "Year", value.name = "Dollars")
head(melt00)
melt00$Year <- as.numeric(str_sub(melt00$Year, 3, 6))
head(melt00)
tail(melt00)

melt00 %>% group_by(Program.Name, Year) %>% 
  summarise(meanDollar = mean(Dollars, na.rm = TRUE))

melt00 %>% group_by(Program.Name, Year) %>% summarise(meanDollar = sum(Dollars, na.rm = TRUE))
?summarise

meltAgg$Program.Name <- meltAgg$Program.Name %>% str_sub(., 1, 10)
