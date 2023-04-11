# Program: two_way_ANOVA.R

# Programmer: Sora Shin

# Objective(s):
#   To analyze variance of BOD treatment with rainfall depth and base flow

## Clear workspace
dev.off()     # clear all plots
rm(list=ls()) # clear global Environmental
cat("\f")     # clear Console

## Install required library
install.packages("psych")       # for descriptive statistics
install.packages("DescTools")   # for post-hoc analysis

## Attach library
library(psych)                  # for descriptive statistics
library(DescTools)              # for post-hoc analysis

## Data loading
df <- read.csv("test_ANOVA_02.csv", header=TRUE)
data <- data.frame(df) # raw data saved as variable 'data'

## Variables assigning
bod <- data$BOD.treatment        # dependent variable             
rainfall <- data$Rainfall.Depth  # independent variable 1 
baseQ <- data$Base.Flow          # independent variable 2  

## Descriptive statistics (number of data, mean, standard deviation, ...)
describe(bod)
describeBy(bod, rainfall)
describeBy(bod, baseQ)

## two-way ANOVA
analysis <- lm(bod ~ as.factor(rainfall)*as.factor(baseQ))
anova(analysis)

## post-hoc analysis
## method option: 
##              "lsd"         -> Fisher's LSD
##              "hsd"         -> Tukey's HSD (Honestly significant difference)
##              "bonf"        -> Duun's (Bonferroni)
##              "scheffe"     -> Scheffe
##              "newmankeuls" -> Newman-Keuls
PostHocTest(aov(analysis), method = "hsd")
