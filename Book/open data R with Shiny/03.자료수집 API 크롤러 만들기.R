install.packages("rstudioapi")
getwd()
setwd(dirname(rstudioapi::getSourceEditorContext()$path))

library(tidyverse)
loc <- read.csv("./Data/01_code/sigun_code/sigun_code.csv", fileEncoding = "UTF-8")
loc <- loc %>% mutate(code = as.character(code))

dateList <- seq(from = as.Date("2021-01-01"),
                to = as.Date("2021-12-31"),
                by = "1 month")

dateList <- format(dateList, format = "%Y%m")
service_key <- "VXTxhjtHzj%2FmfbG47RAquNUIJwFnDJ2MxewAapjVqysjw6TYmiKM0fhtNpoSeKAkLyT7n10OkUVi8e75iQXyLA%3D%3D"
url_list <- list()
cnt <- 0

#크롤링 목록 생성 반복문 작성
#API에 보낼 요청목록 작성
for (i in 1:nrow(loc)) {
  for (j in 1:length(dateList)) {
    cnt <- cnt + 1
    url_list[cnt] <- paste0("http://openapi.molit.go.kr:8081/OpenAPI_ToolInstallPackage/service/rest/RTMSOBJSvc/getRTMSDataSvcAptTrade?",
                            "LAWD_CD=", loc[i,1],
                            "&DEAL_YMD=", dateList[j],
                            "&numOfRows=", 100,
                            "&serviceKey=", service_key)
  }
  Sys.sleep(0.1)
  msg <- paste0("[", i, "/", nrow(loc), "] ", loc[i,3], "의 크롤링 목록이 생성됨 => 총 [", cnt,"] 건")
  cat(msg, "\n\n")
}


length(url_list)
browseURL(paste0(url_list[1]))

#임시저장리스트 만들기
ifelse(!require(XML), install.packages('XML'), library(XML))
library(data.table)
library(stringr)

raw_data <- list()
root_Node <- list()
total <- list()
dir.create("02_raw_data")

for(i in 1:length(url_list)) {
  raw_data[[i]] <- xmlTreeParse(url_list[i], useInternalNodes = TRUE, encoding = "utf-8")
  root_Node[[i]] <- xmlRoot(raw_data[[i]])
  
  items <- root_Node[[i]][[2]][["items"]]
  size <- xmlSize(items)
  
  item <- list()
  item_temp_dt <- data.table()
  Sys.sleep(3)
  
  for(m in 1:size) {
    #거래내역 분리
    item_temp <- xmlSApply(items[[m]], xmlValue)
    item_temp_dt <- data.table(year = item_temp[4],
                               month = item_temp[7],
                               day = item_temp[8],
                               price = item_temp[1],
                               code = item_temp[12],
                               dong_nm = item_temp[5],
                               jibun = item_temp[11],
                               con_year = item_temp[3],
                               apt_nm = item_temp[6],
                               area = item_temp[9],
                               floor = item_temp[13])
    item[[m]] <- item_temp_dt
  }
  apt_bind <- rbindlist(item)
  
  region_nm <- subset(loc, code == str_sub(url_list[i], 115, 119))$addr_1
  month <- str_sub(url_list[i], 130, 135)
  path <- as.character(paste0("./02_raw_data/", region_nm, "_", month, ".csv"))
  write.csv(apt_bind, path)
  msg <- paste0("[", i, "/", length(url_list),
                "] 수집한 데이터를 [", path,"]에 저장 합니다.")
  cat(msg, "\n\n")
}
