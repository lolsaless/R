# Program: Paired_ttest.R

# Programmer: Heewon Jeong

# Objective(s):
#   To compare mean of two paired groups

## Clear workspace
dev.off()     # clear all plots
rm(list=ls()) # clear global Environmental
cat("\f")     # clear Console

## Install required library
install.packages("psych")   # for descriptive statistics

## Attach library
library(psych)              # for descriptive statistics

## Data loading
df <- read.csv("paired-ttest.csv", header=TRUE)
data <- data.frame(df)  # raw data saved as variable 'data'

## Variables assigning
A <- data$BEFORE # SS concentration of before construction 
B <- data$AFTER  # SS concentration of after construction

## Descriptive statistics (number of data, mean, standard deviation, ...)
describe(A)
describe(B)

## Paired t-test
Two_sample <- t.test(A, B, alternative=c("two.sided"), paired=TRUE)
Two_sample
