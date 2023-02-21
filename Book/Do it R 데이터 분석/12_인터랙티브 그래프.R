#인터랙티프 그래프

install.packages("plotly")
library(plotly)
library(ggplot2)

p <- ggplot(mpg, aes(displ, hwy, color = drv)) + geom_point()

ggplotly(p)

a <- ggplot(diamonds, aes(cut, fill = clarity)) +
  geom_bar(position = "dodge")

ggplotly(a)


#인터랙티브 시계열
install.packages("dygraphs")
library(dygraphs)

economic <- economics
head(economic)
library(xts)

eco <- xts(economic$unemploy, order.by = economic$date)
head(eco)

dygraph(eco) %>% dyRangeSelector()

eco_a <- xts(economic$psavert, order.by = economic$date)
eco_b <- xts(economic$unemploy, order.by = economic$date)

rownames_to_column(as.data.frame(eco_a), var = "date") %>% head(5)
eco_a %>% head

eco2 <- cbind(eco_a, eco_b)
head(eco2)
eco2 <- rename(eco2,
               "psavert" = eco_a)

colnames(eco2) <- c("psavert", "unemploy")
head(eco2)

dygraph(eco2) %>% dyRangeSelector()
