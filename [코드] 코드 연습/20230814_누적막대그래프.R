data
# 필요한 패키지를 설치하고 불러옵니다.
install.packages(c("readxl", "ggplot2"))
library(readxl)
library(ggplot2)

# Excel 파일 불러오기
# 필요한 패키지를 설치하고 불러옵니다.
install.packages(c("readxl", "ggplot2"))
library(readxl)
library(ggplot2)

# Excel 파일 불러오기
data <- read_excel("path_to_your_file/data.xlsx")

# 누적 막대 그래프 그리기

# Required Libraries
install.packages("ggplot2")
install.packages("readxl")
library(ggplot2)
library(readxl)

# Read the data
data <- read_excel("/path/to/your/data.xlsx")

# Count the occurrences of '적합' and '부적합' for each 항목
grouped_data <- table(data$항목, data$구분)

# Plot the stacked bar chart
ggplot(as.data.frame(grouped_data), aes(x=Var1, y=Freq, fill=Var2)) +
    geom_bar(stat="identity", position="stack") +
    geom_text(aes(label=Freq), vjust=1.6, color="white", position = position_stack(vjust = 0.5)) +
    scale_fill_manual(values=c("적합"="#ADD8E6", "부적합"="#FFB6C1")) +
    labs(title="누적막대 그래프", x="항목", y="수치", fill="구분") +
    theme_minimal()

# Required Libraries
install.packages("ggplot2")
install.packages("readxl")
library(ggplot2)
library(readxl)

# Read the data
data <- read_excel("/path/to/your/data.xlsx")

# Count the occurrences of '적합' and '부적합' for each 항목
grouped_data <- table(data$항목, data$구분)

# Plot the stacked bar chart
ggplot(as.data.frame(grouped_data), aes(x=Var1, y=Freq, fill=Var2)) +
    geom_bar(stat="identity", position="stack") +
    geom_text(aes(label=Freq), vjust=1.6, color="darkgray", position = position_stack(vjust = 0.5)) +
    scale_fill_manual(values=c("적합"="#ADD8E6", "부적합"="#FFB6C1")) +
    labs(title="누적막대 그래프", x="항목", y="검사 건수", fill="구분") +
    theme_minimal() +
    theme(
        plot.title = element_text(hjust = 0.5, size=20),
        axis.text.x = element_text(size=12),
        axis.text.y = element_text(size=12),
        legend.position = c(0.95, 0.95),
        legend.justification = c("right", "top"),
        legend.box.just = "right",
        legend.margin = margin(6, 6, 6, 6)
    )
