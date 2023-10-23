# Load required libraries
library(ggplot2)
library(readxl)
library(tidyr)
library(ggpubr)

setwd("D:/github/R_coding/북부지원 연구사업")

# Read the data from the excel file
data <- read_excel("o,n_phenol.xlsx")

# Remove rows where NP or OP is 0
data <- data[!(data$NP == 0 | data$OP == 0), ]

# Log transform the data
data$Log_NP <- log(data$NP)
data$Log_OP <- log(data$OP)

# Plot with regression line and group colors
p <- ggplot(data, aes(x=Log_NP, y=Log_OP, color=group)) +
    geom_point() +
    geom_smooth(method='lm', se=FALSE, aes(group=1)) + # overall regression line
    labs(title="Correlation of Log(NP) vs Log(OP)", x="Log(NP)", y="Log(OP)", color="Group") +
    theme_minimal()

# Calculate and print correlation coefficient
cor_coefficient <- cor(data$Log_NP, data$Log_OP)
p + annotate("text", x=min(data$Log_NP), y=max(data$Log_OP), label=paste("R:", round(cor_coefficient, 2)), hjust=0, vjust=1)

# Remove rows where NP or OP is 0
data <- data[!(data$NP == 0 | data$OP == 0), ]

# Log transform the data
data$Log_NP <- log(data$NP)
data$Log_OP <- log(data$OP)

# Plot with regression line, group colors, and repelled labels for Log OP >= 2
p <- ggplot(data, aes(x=Log_NP, y=Log_OP, color=group)) +
    geom_point() +
    geom_smooth(method='lm', se=FALSE, aes(group=1)) + # overall regression line
    geom_text_repel(data=subset(data, Log_OP >= 2), aes(label=round(OP, 2)), nudge_y = 0.5,
                    show.legend = FALSE) +
    labs(title="Correlation of Log(NP) vs Log(OP)", x="Log(NP)", y="Log(OP)", color="Group") +
    theme_minimal()

# Calculate and print correlation coefficient
cor_coefficient <- cor(data$Log_NP, data$Log_OP)
p + annotate("text", x=min(data$Log_NP), y=max(data$Log_OP), label=paste("R:", round(cor_coefficient, 2)), hjust=0, vjust=1)



# Remove rows where NP or OP is 0 or OP is 14 or greater
data <- data[!(data$NP == 0 | data$OP == 0 | data$OP >= 14), ]

# Log transform the data
data$Log_NP <- log(data$NP)
data$Log_OP <- log(data$OP)

# Plot with regression line, group colors, and repelled labels for Log OP >= 2
p <- ggplot(data, aes(x=Log_NP, y=Log_OP, color=group)) +
    geom_point() +
    geom_smooth(method='lm', se=FALSE, aes(group=1)) + # overall regression line
    geom_text_repel(data=subset(data, Log_OP >= 2), aes(label=round(OP, 2)), nudge_y = 0.5,
                    show.legend = FALSE) +
    labs(title="Correlation of Log(NP) vs Log(OP)", x="Log(NP)", y="Log(OP)", color="Group") +
    theme_minimal()

# Calculate and print correlation coefficient
cor_coefficient <- cor(data$Log_NP, data$Log_OP)
p + annotate("text", x=min(data$Log_NP), y=max(data$Log_OP), label=paste("R:", round(cor_coefficient, 2)), hjust=0, vjust=1)

# Read the data from the excel file
data <- read_excel("o,n_phenol.xlsx")

# Plot
p <- ggplot(data, aes(x=NP, y=OP, color=group)) +
    geom_point() +
    geom_abline(intercept=0, slope=1, linetype=2, color="black") +
    geom_text_repel(data=subset(data, Log_OP >= 2), aes(label=round(OP, 2)), nudge_y = 0.5,
                    show.legend = FALSE) +
    labs(title="Scatter plot of NP vs OP", x="NP", y="OP", color="Group") +
    theme_minimal()

# Print R squared value
model <- lm(OP ~ NP, data=data)
r2 <- summary(model)$r.squared
cat("R squared value:", r2, "\n")

# Display the plot
print(p)


######
# Load required libraries
library(ggplot2)
library(readxl)
library(ggrepel)

# Read the data from the excel file
data <- read_excel("o,n_phenol.xlsx")

# Remove rows where OP is 100 or greater
data <- data[data$OP < 100, ]

# Plot
p <- ggplot(data, aes(x=NP, y=OP, color=group)) +
    geom_point() +
    geom_abline(intercept=0, slope=1, linetype=2, color="black") +
    geom_text_repel(data=subset(data, OP >= 2), aes(label=round(OP, 2)), nudge_y = 0.5,
                    show.legend = FALSE) +
    labs(title="Scatter plot of NP vs OP", x="NP", y="OP", color="Group") +
    theme_minimal()

# Print R squared value
model <- lm(OP ~ NP, data=data)
r2 <- summary(model)$r.squared
cat("R squared value:", r2, "\n")

# Display the plot
print(p)

