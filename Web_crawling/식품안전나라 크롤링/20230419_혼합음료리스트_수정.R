data <- read_excel("D:/R_coding/Web_crawling/식품안전나라 크롤링/혼합음료 리스트.xlsx")

colnames(data)
table(unique(data$성분174))

sapply(data, function(x) {
    table(unique(x))
})