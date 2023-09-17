# ggplot2 패키지를 로드합니다. 설치되어 있지 않다면 설치부터 진행해야 합니다.
if (!require(ggplot2)) {
    install.packages("ggplot2")
    library(ggplot2)
}

# reshape2 패키지를 로드합니다. 설치되어 있지 않다면 설치부터 진행해야 합니다.
if (!require(reshape2)) {
    install.packages("reshape2")
    library(reshape2)
}

# csv 파일을 읽습니다. 이때 파일 경로는 실제 파일의 위치에 맞게 변경해야 합니다.
water_data <- read.csv("water_data.csv")

# 데이터를 reshape 합니다. (melt)
water_data_melt <- reshape2::melt(water_data)

# 상자 그림을 그립니다.
ggplot(water_data_melt, aes(x = variable, y = value)) +
    geom_boxplot() +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
    labs(x = "", y = "Value", title = "Box plot of water data")

################################################################################

# ggplot2 패키지를 로드합니다. 설치되어 있지 않다면 설치부터 진행해야 합니다.
if (!require(ggplot2)) {
    install.packages("ggplot2")
    library(ggplot2)
}

# reshape2 패키지를 로드합니다. 설치되어 있지 않다면 설치부터 진행해야 합니다.
if (!require(reshape2)) {
    install.packages("reshape2")
    library(reshape2)
}

# csv 파일을 읽습니다. 이때 파일 경로는 실제 파일의 위치에 맞게 변경해야 합니다.
water_data <- read.csv("water_data.csv")

# Pb, As, Se, Hg만 선택합니다.
selected_data <- water_data[, c("Pb", "As", "Se", "Hg")]

# 선택한 데이터를 reshape 합니다. (melt)
selected_data_melt <- reshape2::melt(selected_data)

# 상자 그림을 그립니다.
ggplot(selected_data_melt, aes(x = variable, y = value)) +
    geom_boxplot() +
    labs(x = "", y = "Value", title = "Box plot of selected water data")

################################################################################

# ggplot2 패키지를 로드합니다. 설치되어 있지 않다면 설치부터 진행해야 합니다.
if (!require(ggplot2)) {
    install.packages("ggplot2")
    library(ggplot2)
}

# reshape2 패키지를 로드합니다. 설치되어 있지 않다면 설치부터 진행해야 합니다.
if (!require(reshape2)) {
    install.packages("reshape2")
    library(reshape2)
}

# csv 파일을 읽습니다. 이때 파일 경로는 실제 파일의 위치에 맞게 변경해야 합니다.
water_data <- read.csv("water_data.csv")

# Pb, As, Se, Hg만 선택합니다.
selected_data <- water_data[, c("No", "Pb", "As", "Se", "Hg")]

# 선택한 데이터를 reshape 합니다. (melt)
selected_data_melt <- reshape2::melt(selected_data, id.vars = "No")

# 'No'가 'A'인 경우의 데이터만 선택합니다.
a_data <- subset(selected_data_melt, No == "A")

# 상자 그림을 그립니다.
ggplot(selected_data_melt, aes(x = variable, y = value)) +
    geom_boxplot() +
    geom_point(data = a_data, aes(x = variable, y = value), color = "red") +
    labs(x = "", y = "Value", title = "Box plot of selected water data")

################################################################################

# ggplot2 패키지를 로드합니다. 설치되어 있지 않다면 설치부터 진행해야 합니다.
if (!require(ggplot2)) {
    install.packages("ggplot2")
    library(ggplot2)
}

# reshape2 패키지를 로드합니다. 설치되어 있지 않다면 설치부터 진행해야 합니다.
if (!require(reshape2)) {
    install.packages("reshape2")
    library(reshape2)
}

# csv 파일을 읽습니다. 이때 파일 경로는 실제 파일의 위치에 맞게 변경해야 합니다.
water_data <- read.csv("water_data.csv")

# Pb, As, Se, Hg만 선택합니다.
selected_data <- water_data[, c("No", "Pb", "As", "Se", "Hg")]

# 선택한 데이터를 reshape 합니다. (melt)
selected_data_melt <- reshape2::melt(selected_data, id.vars = "No")

# 'No'가 'A'인 경우의 데이터만 선택합니다.
a_data <- subset(selected_data_melt, No == "A")

# 상자 그림을 그립니다.
ggplot(selected_data_melt, aes(x = variable, y = value)) +
    geom_boxplot() +
    geom_point(data = a_data, aes(x = variable, y = value), color = "red") +
    geom_text(data = a_data, aes(x = variable, y = value, label = No), color = "black", hjust = -1) +
    labs(x = "", y = "Value", title = "Box plot of selected water data")
