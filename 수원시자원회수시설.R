install.packages('httr')
install.packages('rvest')
install.packages()
library(httr, rvest)

library(rvest)

Sys.setlocale('LC_ALL', 'English')
url <- 'http://www.rrfsuwon.co.kr/_Skin/24_1.php'

data <- POST(url, body =
               list(
             gubun = 'period',
             sYear = '2020',
             sMonth = '10',
             sDate = '2020-01-01',
             eDate = '2020-10-31'
))

data <- read_html(data) %>%
  html_table(fill=T) %>%
  .[[1]]

Sys.setlocale('LC_ALL', 'Korean')


print(data
      )

library(stringr)
str_replace_all(data$일자,'\\.','')
data <- data(,1(str_replace_all(data$일자,'\\.','')))


data[,1]
data[,1] <- '1'
data
data11 <- data



data[,1] <- str_replace_all(data$일자,'\\.','')
data2 <- data[,-1]

data3 <- data[-1,]

data4 <- data3[-310,]
