# Program: one_way_ANOVA.R

# Programmer: Sora Shin

# Objective(s):
#   To analyze variance in temperature with season

## Clear workspace
dev.off()     # clear all plots
rm(list=ls()) # clear global Environmental
cat("\f")     # clear Console

## Install required library
install.packages("ggplot2")     # for box plot
install.packages("psych")       # for descriptive statistics
install.packages("DescTools")   # for post-hoc analysis

## Attach library
library(ggplot2)                # for box plot
library(psych)                  # for descriptive statistics
library(DescTools)              # for post-hoc analysis

## Data loading
df <- read.csv("test_ANOVA_01.csv", header=TRUE)
data <- data.frame(df) # raw data saved as variable 'data'

## Variables assigning
season <- data$Season         # independent variable
temperature <- data$Temp      # dependent variable

## Box plot
boxplot(temperature ~ as.factor(season), vertical=T,
        pch=19, xlab="Seasons", ylab="Temperature")

## Descriptive statistics (number of data, mean, standard deviation, ...)
describe(temperature)
describeBy(temperature, season)

## one-way ANOVA
analysis <- lm(temperature ~ as.factor(season))
anova(analysis)

## post-hoc analysis
## method option: 
##              "lsd"         -> Fisher's LSD
##              "hsd"         -> Tukey's HSD (Honestly significant difference)
##              "bonf"        -> Duun's (Bonferroni)
##              "scheffe"     -> Scheffe
##              "newmankeuls" -> Newman-Keuls
PostHocTest(aov(analysis), method="scheffe")
