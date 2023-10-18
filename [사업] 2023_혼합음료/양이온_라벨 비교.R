# R Code for Data Transformation and Plotting

## Importing Libraries
library(readxl)
library(ggplot2)
library(car)
library(tidyverse)

## Reading Data
df <- read_excel("ca_data.xlsx")

## Data Transformation
# Transforming Ca
df$Transformed_Ca <- df$Ca - df$Ca_max

# Log Transformation
df$Log_Ca_max <- log(df$Ca_max + 1)
df$Log_Ca <- log(df$Ca + 1)

# Log Transformed Ca
df$Transformed_Log_Ca <- df$Log_Ca - df$Log_Ca_max

## Plotting
# Histogram
ggplot(df, aes(x=Transformed_Ca)) +
    geom_histogram(aes(y=..density..), bins=20, alpha=.5) +
    geom_density() +
    ggtitle("Histogram of Transformed_Ca")

# QQ-Plot
qqPlot(df$Transformed_Ca, main="QQ-Plot of Transformed_Ca")

## Adding row numbers
df <- df %>% mutate(row_num = row_number())

## Plotting
ggplot(df, aes(x=row_num, y=Transformed_Log_Ca, color=part)) +
    geom_point() +
    geom_hline(yintercept=0, linetype="dashed", color = "red") +
    labs(title="Transformed Log Ca Values by Part", x="Index", y="Transformed_Log_Ca") +
    theme_minimal()


##ggplot + density

## Removing NaN rows
df <- df %>% drop_na(Transformed_Log_Ca)

## ChatGPT
dens_obj <- density(df$Transformed_Log_Ca)

# Interpolate density values to match the length of df
# 여기서 보간 방법을 선택해야 합니다. 예를 들어, approx 함수를 사용할 수 있습니다.
interp_dens <- approx(dens_obj$x, dens_obj$y, xout = df$Transformed_Log_Ca)$y

# Add interpolated density values to df
df$density <- interp_dens

## Adding row numbers
df <- df %>% mutate(row_num = row_number())

## ChatGPT
p <- ggplot(df, aes(x=row_num, y=Transformed_Log_Ca, color=density, shape=part)) +
    geom_point() +
    scale_shape_manual(values = c(2, 1)) +
    geom_hline(yintercept=0, linetype="dashed", color = "red") +
    labs(title="Transformed Log Ca Values by Part with Den sity", x="Index", y="Transformed_Log_Ca") +
    theme_minimal() +
    scale_colour_gradient(low="blue", high="yellow")

## ChatGPT
# 범주를 만드는 예시 코드
df$density_cat <- cut(df$density, breaks = c(-Inf, 0.1, 0.2, 0.3, Inf), labels = c("Low", "Medium", "High", "Very High"))

# ggplot 코드
ggplot(df, aes(x=row_num, y=Transformed_Log_Ca, color=density_cat, shape=part)) +
    geom_point() +
    scale_shape_manual(values = c(2, 1)) +
    geom_hline(yintercept=0, linetype="dashed", color = "red") +
    geom_hline(yintercept=c(0.5, -0.5), linetype="solid", color = "black") +
    labs(title="Transformed Log Ca Values by Part with Density", x="Index", y="Transformed_Log_Ca") +
    theme_minimal() +
    scale_colour_manual(values = c("Low" = "blue", "Medium" = "green", "High" = "yellow", "Very High" = "red"))

## 라벨 추가하기
# ggplot2과 ggrepel 라이브러리를 로드합니다.
library(ggrepel)

# 1 이상 또는 -1 이하인 데이터 포인트에 대해 geom_text_repel을 사용합니다.
p + geom_text_repel(
    data = subset(df, Transformed_Log_Ca >= 1 | Transformed_Log_Ca <= -1),
    aes(label = sprintf("%.2f", Ca)),  # Ca 값을 소수점 둘째자리까지 표시합니다.
    box.padding = 0.5,  # 텍스트와 점 사이의 거리를 설정합니다.
    point.padding = 0.5  # 텍스트와 다른 텍스트 사이의 거리를 설정합니다.
)

# ggplot2과 ggrepel 라이브러리를 로드합니다.
library(ggplot2)
library(ggrepel)

# ggplot을 사용하여 그래프를 그립니다.
p <- ggplot(df, aes(x=row_num, y=Transformed_Log_Ca, color=part, shape=part)) +
    geom_point() +  # 점을 그립니다.
    geom_hline(yintercept=0, linetype="dashed", color = "red") +  # y=0에 대한 점선을 추가합니다.
    geom_hline(yintercept=c(0.5, -0.5), linetype="solid", color = "black") +  # y=0.5, y=-0.5에 대한 실선을 추가합니다.
    labs(title="Transformed Log Ca Values by Part", x="Index", y="Transformed_Log_Ca") +  # 라벨과 제목을 설정합니다.
    theme_minimal()  # 테마를 설정합니다.

# 1 이상 또는 -1 이하인 데이터 포인트에 대해 geom_text_repel을 사용합니다.
p + geom_text_repel(
    data = subset(df, Transformed_Log_Ca >= 1 | Transformed_Log_Ca <= -1),
    aes(label = sprintf("%.2f", Ca)),  # Ca 값을 소수점 둘째자리까지 표시합니다.
    box.padding = 0.5,  # 텍스트와 점 사이의 거리를 설정합니다.
    point.padding = 0.5  # 텍스트와 다른 텍스트 사이의 거리를 설정합니다.
)

