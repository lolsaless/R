library(httr)
library(rvest)
library(jsonlite)


url11 <- 'http://index.wisefn.co.kr/Index/GetIndexComponets?ceil_yn=0&dt=20201109&sec_cd=G10'
data = fromJSON(url11)



Sys.setlocale('LC_ALL', 'English')
url <- 'https://air.gg.go.kr/default/tms.do'
data <- POST(url, body =
               list(
                 op = 'getByLoc',
                 fromDt =  '2019-11-11',
                 toDt = '2020-11-10',
                 locCd = '131611',
                 typeCd = '2'))
Sys.setlocale('LC_ALL', 'Korean')

print(data1)
data11 <- list(data)
