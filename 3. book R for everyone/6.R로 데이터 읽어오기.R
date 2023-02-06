tomato <- read.table(file = "Tomato First.csv", header = TRUE, sep = ",")
getwd()
setwd("D:/R_coding/3. book R for everyone")

view(tomato)
head(tomato)

tomato2 <- read.table(file = "Tomato First.csv", header = FALSE, sep = ",")
tomato2

tomato
x <- tomato$Overall
y <- tomato$Acid
z <- tomato$Tomato

tomato3 <- data.frame(x,y,z)
tomato3$z
class(tomato3$z)
tomato4 <- data.frame(x,y,z, stringsAsFactors = FALSE)
tomato4$z

b <- LETTERS[1:100]
class(b)
b <- factor(1:100)
b
aftomato <- as.factor(tomato$Tomato)
aftomato

tomato5 <- data.frame(x, y, aftomato)
tomato5$aftomato
class(tomato5$aftomato)

tomato6 <- data.frame(x, y, aftomato, stringsAsFactors = FALSE)
class(tomato6$aftomato)

library(readr)
theURL
Dtomato <- read_delim(file = theURL, delim = ',')
Dtomato

library(data.table)
dttomato <- fread(input = theURL, header = TRUE, sep = ",")
dttomato
class(dttomato)

#6.2엑셀데이터
library(readxl)
excel_sheets("ExcelExample.xlsx")
tomatoXL <- read_excel("ExcelExample.xlsx")
tomatoXL

colnames(tomatoXL)

unique(tomatoXL$Tomato)

mpg %>% filter(year == 1999) %>%
  group_by(manufacturer) %>% 
  summarise(mean_hwy = mean(hwy),
            mean_displ = mean(displ)) %>% 
  head(3)

windXL1 <- read_excel("ExcelExample.xlsx", sheet = 2)
dim(windXL1)

diamonds
dim(diamonds)

diamonds %>% group_by(cut) %>% 
  summarise(Prices = mean(price)) %>% 
  arrange(desc(Prices))

#크롤링
library(rvest)
ribalta <- read_html("https://jaredlander.com/data/ribalta.html")

class(ribalta)

ribalta %>% html_nodes('ul') %>% html_nodes('span')
ribalta %>% html_nodes('.street')

ribalta %>% html_nodes("table.food-items") %>% 
  magrittr::extract(.,1:4) %>% 
  html_table()

?extract
?html_nodes
