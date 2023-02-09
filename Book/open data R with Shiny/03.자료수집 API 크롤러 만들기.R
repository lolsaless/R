install.packages("rstudioapi")
getwd()

library(tidyverse)
loc <- read.csv("./Data/01_code/sigun_code/sigun_code.csv", fileEncoding = "UTF-8")
loc <- loc %>% mutate(code = as.character(code))

dateList <- seq(from = as.Date("2021-01-01"),
                to = as.Date("2021-12-31"),
                by = "1 month")

dateList <- format(dateList, format = "%Y%m")
service_key <- "BQldryWdzJst6neFJIkd5g4JPySr3dfWfOA35vpPlXpyuJ8afcm7KVDWRO4E58jTGJXiyJVy2fBybwTRAVDDkA%3D%3D"
url_list <- list()
cnt <- 0

length(url_list)
browseURL(paste0(url_list[1]))



#크롤링 반복문 작성
for (i in 1:nrow(loc)) {
  for (j in 1:length(dateList)) {
    cnt <- cnt + 1
    url_list[cnt] <- paste0("http://openapi.molit.go.kr:8081/OpenAPI_ToolInstallPackage/service/rest/RTMSOBJSvc/getRTMSDataSvcAptTrade?",
                            "LAWD_CD=", loc[i,1],
                            "&DEAL_YMD=", dateList[j],
                            "&numOfRows=", 100,
                            "&serviceKey=", service_key)
  }
  Sys.sleep(3)
  msg <- paste0("[", i, "/", nrow(loc), "] ", loc[i,3], "의 크롤링 목록이 생성됨 => 총 [", cnt,"] 건")
  cat(msg, "\n\n")
}
