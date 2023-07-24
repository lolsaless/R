library(plotly)
library(plyr)

data_mean <- ddply(ToothGrowth, c("supp", "dose"), summarise, length = mean(len))
data_sd <- ddply(ToothGrowth, c("supp", "dose"), summarise, length = sd(len))
data <- data.frame(data_mean, data_sd$length)
data <- rename(data, c("data_sd.length" = "sd"))
data$dose <- as.factor(data$dose)

fig <- plot_ly(data = data[which(data$supp == 'OJ'),], x = ~dose, y = ~length, type = 'bar', name = 'OJ',
               error_y = ~list(array = sd,
                               color = '#000000'))
fig <- fig %>% add_trace(data = data[which(data$supp == 'VC'),], name = 'VC')

fig

data_mean
data_sd
data
str(data)
data
