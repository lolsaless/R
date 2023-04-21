# Program: Non_parametric_KWtest.R

# Programmer: Sora Shin

# Objective(s):
#   To perform Kruskal Wallis testw

## Clear workspace
dev.off()     # clear all plots
rm(list=ls()) # clear global Environmental
cat("\f")     # clear Console

## Install required library
install.packages("psych")       # for descriptive statistics
install.packages("ggplot2")     # for box plot

## Attach library
library(psych)                  # for descriptive statistics
library(ggplot2)                # for box plot

## Data loading
df <- read.csv("kwtest.csv", header=TRUE)
data <- data.frame(df) # raw data saved as variable 'data'

## Variables assigning
soya <- data$soya    
sperm <- data$sperm
ranks <- data$ranks

## Normality check
#  Shapiro-wilk normality test depending on the soya uptake period
soya1 <- subset(data, soya==1)
soya2 <- subset(data, soya==2)
soya3 <- subset(data, soya==3)
soya4 <- subset(data, soya==4)
shapiro.test(soya1$sperm)
shapiro.test(soya2$sperm)
shapiro.test(soya3$sperm)
shapiro.test(soya4$sperm)

## Descriptive statistics (number of data, mean, standard deviation, ...)
describe(sperm)
describe(soya)

## Box plot
boxplot(sperm ~ as.factor(soya), vertical=T,
        pch=19, xlab="Soya", ylab="Sperm")

## Kruskal-Wallis test
kw <- kruskal.test(sperm ~ as.factor(soya))
kw
