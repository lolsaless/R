
setwd("~/Documents/GitHub/R/[업무] 실내공기 분기 보고")

data_df <- read.csv('data.csv')
result_df <- read.csv('result.csv')

merged_df <- merge(data_df, result_df, by='접수번호', all=FALSE)

filtered_df <- merged_df[grepl('실내공기질', merged_df$검체유형_x, ignore.case=FALSE), ]

filtered_df$시설군 <- sapply(strsplit(filtered_df$검체유형_x, '/'), `[`, 3)

# Step 5: Select required columns
selected_columns <- c('의뢰기관', '시설군', '배출시설', '시설명', '채취장소_x', '시료명_x',
                      'PM-10', 'PM-2.5', 'CO2', 'Formaldehyde', '세균', 'Rn', '부적합항목', '확인일', '접수번호')
extracted_df <- filtered_df[, selected_columns]

# Step 6: Rename columns
colnames(extracted_df) <- c('시군명', '시설군', '세부시설군', '시설명', '주소', '시료명_x',
                            '미세먼지(PM10)', '초미세먼지(PM2.5)', '이산화탄소', '폼알데하이드', 
                            '총부유세균', '라돈', '부적합항목', '확인일', '접수번호')

# Step 7: Create '접수번호_10자리' and '채취지점'
extracted_df$접수번호_10자리 <- substr(extracted_df$접수번호, 1, 10)
extracted_df$채취지점 <- ave(extracted_df$시료명_x, extracted_df$시설명, FUN=function(x) paste(unique(x), collapse=', '))

# Step 8: Calculate the mean of numeric columns grouped by '시설명' and '접수번호_10자리'
numeric_columns <- c('미세먼지(PM10)', '초미세먼지(PM2.5)', '이산화탄소', '폼알데하이드', '총부유세균', '라돈')
data_avg <- aggregate(extracted_df[, numeric_columns], by=list(extracted_df$시설명, extracted_df$접수번호_10자리), mean)
names(data_avg)[1:2] <- c('시설명', '접수번호_10자리')

# Step 9: Merge the average data with non-numeric data
non_numeric_data <- extracted_df[, !(names(extracted_df) %in% numeric_columns)]
non_numeric_data <- non_numeric_data[!duplicated(non_numeric_data[, c('시설명', '접수번호_10자리')]), ]
data_final <- merge(data_avg, non_numeric_data, by=c('시설명', '접수번호_10자리'))

# Step 10: Drop unnecessary columns and sort the data
data_final <- data_final[, !(names(data_final) %in% '시료명_x')]
data_sorted <- data_final[order(data_final$시군명, data_final$시설군, data_final$세부시설군, 
                                data_final$시설명, data_final$주소, data_final$채취지점, 
                                data_final$`미세먼지(PM10)`, data_final$`초미세먼지(PM2.5)`, 
                                data_final$이산화탄소, data_final$폼알데하이드, data_final$총부유세균, data_final$라돈), ]

# Step 11: Save the final report
output_path <- 'report_data.csv'
write.csv(data_sorted, file=output_path, row.names=FALSE)
